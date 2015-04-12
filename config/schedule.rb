# Environment
rails_env = ENV['RAILS_ENV'] || :development

set :environment, rails_env
set :output, 'log/crontab.log'

# Production Only
if rails_env.to_sym.eql?(:production)
  every 5.minutes do
    rake 'pesca:run'
  end
end
