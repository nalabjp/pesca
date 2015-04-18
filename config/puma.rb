workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

@sidekiq_pid = nil

def sidekiq_boot?
  by_foreman = begin
    IO.foreach(Rails.root.join('Procfile')).any?{|line| line.include?('sidekiq')}
  rescue
    false
  end
  File.exists?(Rails.root.join('config/sidekiq.yml')) && by_foreman.!
end

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection

  if sidekiq_boot?
    @sidekiq_pid ||= spawn('bundle exec sidekiq -C config/sidekiq.yml')
    Rails.logger.info("Spawned sidekiq #{@sidekiq_pid}")
  end
end

on_worker_shutdown do
  Process.kill('kill', @sidekiq_pid) if @sidekiq_pid
end
