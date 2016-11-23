source 'https://rubygems.org'

# Server
gem 'puma', '~> 3.0'
gem 'pg', '~> 0.19.0'
gem 'syslog-logger', '~> 1.6.8'
gem 'redis-rails', '~> 5.0.1'
gem 'redis-namespace', '~> 1.5.2'
gem 'newrelic_rpm', '~> 3.16.2.321'
gem 'good_migrations', '~> 0.0.2'

# Framework
gem 'rails', '~> 4.2.7.1'
gem 'activeadmin', '~> 1.0.0.pre4'
gem 'paper_trail', '~> 5.2.2'
gem 'interactor-rails', '~> 2.0.2'
# TODO: gem 'axlsx' requires rubycsv = 1.0. Update roo when that changes
gem 'roo', '~> 1.13.2'

# Authentication
gem 'rack-cas', '~> 0.15.0'
gem 'pundit', '~> 1.1.0'
gem 'rest-client', '~> 2.0.0'

# Assets
gem 'coffee-rails', '~> 4.1.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

# View Helpers
gem 'countries', '~> 1.2.5'
gem 'phone', '~> 1.2.3'
gem 'truncate_html', '~> 0.9.3'
gem 'chosen-rails', '~> 1.5.2'
gem 'money-rails', '~> 1.7.0'
# TODO: gem 'activeadmin-axlsx', '>= 2.2' when compatible with activeadmin-1.0.0
# TODO: and remove the version in ./lib/active_admin/
gem 'axlsx', '~> 2.0.1'

# Frontend Scripts
gem 'turbolinks', '~> 5.0.1'
gem 'ckeditor', '~> 4.2.0'
gem 'jquery-rails'
gem 'intl-tel-input-rails', '~> 8.4.9'


group :development, :test do
  gem 'sqlite3', '~> 1.3.11'
  gem 'dotenv-rails', '~> 2.1.1'

  # Testing
  gem 'byebug'
  gem 'factory_girl', '~> 4.7.0'
  gem 'faker', '~> 1.6.6'
  gem 'rubocop', '~> 0.42.0'
  gem 'guard', '~> 2.14.0'
  gem 'guard-minitest', '~> 2.4.6'
  gem 'minitest-reporters', '~> 1.1.11'
  gem 'webmock', '~> 2.1.0'
  gem 'reek', '~> 4.4.2'
  gem 'bundler-audit', '~> 0.5.0'

  # Documentation
  gem 'yard', '~> 0.9.5'
end

group :development do
  # Development Server
  gem 'spring'
  gem 'web-console', '~> 2.0'

  # Deployment
  # TODO gem 'capistrano-rails'
end

