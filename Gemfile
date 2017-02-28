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
gem 'cells-rails', '~> 0.0.7'

# Frontend Scripts
gem 'turbolinks', '~> 5.0.1'
gem 'ckeditor', '~> 4.2.0'
gem 'jquery-rails'
gem 'intl-tel-input-rails', '~> 8.4.9'


group :development, :test do
  gem 'dotenv-rails', '~> 2.1.1'

  # Testing
  gem 'byebug'                            # Debugger
  gem 'factory_girl', '~> 4.7'            # Test object factories
  gem 'faker', '~> 1.6'                   # Fake data generator
  gem 'rubocop', '~> 0.42'                # Linter
  gem 'guard', '~> 2.14'                  # Continuous testing
  gem 'guard-minitest', '~> 2.4'          # ""
  gem 'minitest-reporters', '~> 1.1'      # Test output format
  gem 'minitest-rails-capybara', '~> 2.1' # Integration tests
  gem 'selenium-webdriver', '~> 3.2'      # Integration tests javascript support
  gem 'rack_session_access', '~> 0.1'     # Edit user-agent session
  gem 'webmock', '~> 2.1'                 # Stub HTTP requests
  gem 'reek', '~> 4.4'                    # Linter
  gem 'bundler-audit', '~> 0.5'           # Linter
  gem 'database_cleaner', '~> 1.5'        # Truncates the DB after each test

  # Documentation
  gem 'yard', '~> 0.9.5'
end

group :development do
  # Development Server
  gem 'spring'
  gem 'web-console', '~> 2.0'
  gem 'pry-rails', '~> 0.3.4'

  # Deployment
  # TODO gem 'capistrano-rails'
end

