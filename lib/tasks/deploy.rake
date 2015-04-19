#Deploy and rollback on Heroku in staging and production

%w(staging production).each do |app|
  desc "Deploy to #{app}"
  task "deploy:#{app}" => %W(deploy:set_#{app}_app deploy:push deploy:env deploy:restart deploy:tag app:logs)

  desc "Deploy #{app} with migrations"
  task "deploy:#{app}:migrations" => %W(deploy:set_#{app}_app deploy:push deploy:off deploy:migrate deploy:env deploy:restart deploy:on deploy:tag app:logs)

  desc "Rollback #{app}"
  task "deploy:#{app}:rollback" => %W(deploy:set_#{app}_app deploy:off deploy:push_previous deploy:restart deploy:on app:logs)

  %w(logs config ps releases).each do |app_task|
    desc "#{app} #{app_task}"
    task "app:#{app}:#{app_task}" => %W(deploy:set_#{app}_app app:#{app_task})
  end
end

namespace :deploy do
  PRODUCTION_APP = Rails.application.class.parent_name.downcase
  STAGING_APP = 'YOUR_STAGING_APP_NAME_ON_HEROKU'

  task :set_staging_app do
    raise 'NOT SET +STAGING_APP+' if !STAGING_APP || STAGING_APP.empty? || STAGING_APP == 'YOUR_STAGING_APP_NAME_ON_HEROKU'
    APP = STAGING_APP
  end

  task :set_production_app do
    raise 'NOT SET +PRODUCTION_APP+' if !PRODUCTION_APP || PRODUCTION_APP.empty? || PRODUCTION_APP == 'YOUR_PRODUCTION_APP_NAME_ON_HEROKU'
    APP = PRODUCTION_APP
  end

  task :push do
    git_status = `git status -v`
    abort('local branch is out of sync with github origin. please push there first') if git_status.match(/\*[^\]]+?\[ahead|behind/s) != nil
    current_branch = `git rev-parse --abbrev-ref HEAD`.chomp
    current_branch += ':master' if current_branch != 'master'
    puts "Deploying #{current_branch} to #{APP} ..."
    puts `git push -f git@heroku.com:#{APP}.git #{current_branch}`
  end

  task :restart do
    puts 'Restarting app servers ...'
    Bundler.with_clean_env do
      puts `heroku restart --app #{APP}`
    end
  end

  task :tag do
    release_name = "#{APP}-release-#{Time.now.utc.strftime('%Y%m%d%H%M%S')}"
    puts "Tagging release as '#{release_name}'"
    puts `git tag -a #{release_name} -m 'Tagged release'`
    puts `git push --tags git@heroku.com:#{APP}.git`
  end

  task :migrate do
    puts 'Running database migrations ...'
    Bundler.with_clean_env do
      puts `heroku rake db:migrate --app #{APP}`
    end
  end

  task :env do
    dotenvrc = Rails.root.join('.envrc')
    dotenv = Rails.root.join('.env')
    if File.exists?(dotenvrc)
      envrc = IO.readlines(dotenvrc).map do |line|
        line.sub(/\Aexport /, '').chomp! if line =~ /\Aexport (?!PATH=)/
      end.compact
      File.open(dotenv, 'w'){|file| file.write(envrc.join("\n").concat("\n"))}
      puts 'Setting env ...'
      Bundler.with_clean_env do
        puts `heroku config:push --app #{APP}`
      end
    end
  end

  task :off do
    puts 'Putting the app into maintenance mode ...'
    Bundler.with_clean_env do
      puts `heroku maintenance:on --app #{APP}`
    end
  end

  task :on do
    puts 'Taking the app out of maintenance mode ...'
    Bundler.with_clean_env do
      puts `heroku maintenance:off --app #{APP}`
    end
  end

  task :push_previous do
    prefix = "#{APP}-release-"
    releases = `git tag`.split("\n").select { |t| t[0..prefix.length-1] == prefix }.sort
    current_release = releases.last
    previous_release = releases[-2] if releases.length >= 2
    if previous_release
      puts "Rolling back to '#{previous_release}' ..."

      puts "Checking out '#{previous_release}' in a new branch on local git repo ..."
      puts `git checkout #{previous_release}`
      puts `git checkout -b #{previous_release}`

      puts "Removing tagged version '#{previous_release}' (now transformed in branch) ..."
      puts `git tag -d #{previous_release}`
      puts `git push git@heroku.com:#{APP}.git :refs/tags/#{previous_release}`

      puts "Pushing '#{previous_release}' to Heroku master ..."
      puts `git push git@heroku.com:#{APP}.git +#{previous_release}:master --force`

      puts "Deleting rollbacked release '#{current_release}' ..."
      puts `git tag -d #{current_release}`
      puts `git push git@heroku.com:#{APP}.git :refs/tags/#{current_release}`

      puts "Retagging release '#{previous_release}' in case to repeat this process (other rollbacks)..."
      puts `git tag -a #{previous_release} -m 'Tagged release'`
      puts `git push --tags git@heroku.com:#{APP}.git`

      puts 'Turning local repo checked out on master ...'
      puts `git checkout master`
      puts 'All done!'
    else
      puts "No release tags found - can't roll back!"
      puts releases
    end
  end
end

namespace :app do
  task :logs do
    puts 'tailing logs...'
    Bundler.clean_exec "heroku logs --tail --app #{APP}"
  end

  task :config do
    puts 'config...'
    Bundler.with_clean_env do
      puts `heroku config --app #{APP}`
    end
  end

  task :ps do
    puts 'running processes...'
    Bundler.with_clean_env do
      puts `heroku ps --app #{APP}`
    end
  end

  task :releases do
    puts 'releases...'
    Bundler.with_clean_env do
      puts `heroku releases --app #{APP}`
    end
  end
end
