source 'https://rubygems.org'

ruby '3.1.2'

gem 'rails', '~> 7.0.4'
gem 'puma'
gem 'webpacker'
gem 'turbolinks'
gem 'bootsnap', require: false
gem 'rails_admin'
gem 'sqlite3'

group :development do
  gem 'web-console', '>= 4.1.0'
  gem 'listen', '~> 3.3'
  gem 'spring'

  # use capistrano for production deployment
  gem 'capistrano', '~> 3.11'
  gem 'capistrano-rails', '~> 1.4'
  gem 'capistrano-passenger', '~> 0.2.0'
  gem 'capistrano-rbenv', '~> 2.1', '>= 2.1.4'
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'shoulda-matchers', '~> 5.0'
  gem 'webmock'
  gem 'rails-controller-testing'
end
