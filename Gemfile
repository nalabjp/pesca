source 'https://rubygems.org'

# for heroku
ruby '2.2.1'
group :production do
  gem 'rails_12factor'
  gem 'newrelic_rpm'
end

# rails base
gem 'rails', '4.2.1'
gem 'pg'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

# server
gem 'puma'

# foreman
gem 'foreman'

# http
gem 'faraday'
gem 'faraday_middleware'

# db
gem 'hirb'
gem 'hirb-unicode'

# bulk insert for AR
gem 'activerecord-import'

# hash extension
gem 'hashie'

# search
gem 'ransack'

# actor
gem 'celluloid'

# pushbullet
gem 'washbullet', github: 'nalabjp/washbullet'

# state machine
gem 'aasm'

# activejob backend
gem 'sucker_punch'

# HTML to Text
gem 'nokogiri'

group :development, :test do
  gem 'web-console'
  gem 'spring'
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-doc'
  gem 'pry-stack_explorer'
  gem 'pry-byebug'
  gem 'pry-rescue'
  gem 'pry-remote'
  gem 'pry-power_assert'
  gem 'awesome_print'
  gem 'timecop'
  gem 'tapp'
  gem 'bullet'
  gem 'factory_girl_rails'
end

group :development do
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'annotate'
end

