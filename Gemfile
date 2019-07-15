source 'https://rubygems.org'
source 'https://gems.contribsys.com/' do
  gem 'sidekiq-pro'
end

# Server
gem 'good_migrations', '~> 0.0.2'
gem 'newrelic_rpm', '~> 4.0'
gem 'pg', '~> 0.19.0'
gem 'puma', '~> 3.0'
gem 'syslog-logger', '~> 1.6.8'

# Background Processes
gem 'redis-namespace', '~> 1.5'
gem 'redis-objects', '~> 0.6'
gem 'redis-rails', '~> 5.0'
gem 'sidekiq-cron', '~> 1.1'
gem 'sidekiq-failures'
gem 'sidekiq-unique-jobs'

# Error Reporting
gem 'ddtrace'
gem 'dogstatsd-ruby'
gem 'oj', '>= 2.18'
gem 'rollbar', '~> 2.18'

# Framework
gem 'activeadmin', '~> 1.0.0'
gem 'acts_as_list', '~> 0.9'
gem 'paper_trail', '~> 5.2.2'
gem 'rails', '~> 4.2.11'
gem 'roo', '~> 2.7'

# Authentication
gem 'pundit', '~> 1.1.0'
gem 'rack-cas', '~> 0.15.0'
gem 'rest-client', '~> 2.0.0'

# Assets
gem 'coffee-rails', '~> 4.1.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

# View Helpers
# TODO: gem 'activeadmin-axlsx', '>= 2.2' when compatible with activeadmin-1.0.0
# TODO: and remove the version in ./lib/active_admin/
gem 'axlsx', '~> 3.0.0.pre'
gem 'chosen-rails', '~> 1.5.2'
gem 'compass-rails', '~> 3.0'
gem 'countries', '~> 1.2.5'
gem 'money-rails', '~> 1.7'
gem 'phone', '~> 1.2.3'
gem 'prawn', '~> 2.2'
gem 'prawn-table', '~> 0.2'
gem 'truncate_html', '~> 0.9.3'

# Frontend Scripts
gem 'ckeditor_rails', '~> 4.6'
gem 'intl-tel-input-rails', '~> 8.4.9'
gem 'jquery-rails', '~> 4.2'
gem 'jquery-ui-rails', '~> 5.0'
gem 'turbolinks', '~> 5.0.1'

# Interface with DocuSign
gem 'docusign_rest', '~> 0.4.4'

# We don't require Nokogiri directly, only through other gems (like axlsx).
# However, due to CVE's, we need to ensure we're using a recent version.
gem 'nokogiri', '~> 1.10.3'

group :development, :test do
  gem 'dotenv-rails', '~> 2.5.0'

  # Testing
  gem 'bundler-audit', '~> 0.5'           # Linter
  gem 'capybara-screenshot'
  gem 'coffeelint', '~> 1.16'             # Coffeescript Linter
  gem 'database_cleaner', '~> 1.5'        # Truncates the DB after each test
  gem 'factory_girl', '~> 4.7'            # Test object factories
  gem 'faker', '~> 1.6'                   # Fake data generator
  gem 'guard', '~> 2.14'                  # Continuous testing
  gem 'guard-minitest', '~> 2.4'          # ""
  gem 'letter_opener', '~> 1.7.0'         # Preview email on browser instead of sending
  gem 'm', '~> 1.5.0'                     # Allow to run individual tests
  gem 'minitest', '~> 5.10.2'
  gem 'minitest-around', '~> 0.4'         # Minitest around callback
  gem 'minitest-rails-capybara', '~> 2.1' # Integration tests
  gem 'minitest-reporters', '~> 1.1'      # Test output format
  gem 'mocha', '~> 1.7.0'                 # Test mocking and stubbing
  gem 'pry-byebug', '~> 3.6.0'            # Debugger
  gem 'pry-rails', '~> 0.3.5'
  gem 'rack_session_access', '~> 0.1'     # Edit user-agent session
  gem 'reek', '~> 5.2'                    # Linter
  gem 'rubocop', '~> 0.60'                # Linter
  gem 'selenium-webdriver', '~> 3.2'      # Integration tests javascript support
  gem 'simplecov', '~> 0.15',             # test coverage
      require: false
  gem 'vcr', '~> 4.0.0'                   # Record/Reply HTTP Requests
  gem 'webmock', '~> 2.1'                 # Stub HTTP requests

  # Documentation
  gem 'yard', '~> 0.9.5'
end

group :development do
  # Development Server
  gem 'better_errors'                     # Better Errors
  gem 'binding_of_caller'                 # Better Errors
  gem 'spring'

  # Disabled web-console due to server error `IPAddr::InvalidAddressError: invalid address`
  # gem 'web-console', '~> 2.0'
end
gem 'awesome_print'
gem 'lograge'
gem 'ougai', '~> 1.7'
