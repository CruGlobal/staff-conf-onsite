source 'https://rubygems.org'
source 'https://gems.contribsys.com/' do
  gem 'sidekiq-pro'
end

# Server
gem 'good_migrations', '~> 0.2.1'
gem 'pg', '~> 1.5.0'
gem 'puma', '~> 3.0'
gem 'syslog-logger', '~> 1.6.8'

# Background Processes
gem 'redis-objects', '~> 1.7'
gem 'redis-rails', '~> 5.0'
gem 'sidekiq-cron', '~> 1.1'
gem 'sidekiq-failures'

# Error Reporting
gem 'ddtrace'
gem 'dogstatsd-ruby'
gem 'oj', '>= 2.18'
gem 'rollbar', '~> 2.18'

# Framework
gem 'activeadmin', '~> 2.10.0'
gem 'acts_as_list', '~> 1.0'
gem 'roo', '~> 2.7'

gem 'rails', '~> 6.1.7.3'
gem 'actionpack', '~> 6.1.7.3'
gem 'activerecord', '~> 6.1.7.3'
gem 'activesupport', '~> 6.1.7.3'
gem 'railties', '~> 6.1.7.3'
gem 'lograge', '~> 0.12.0'
gem 'money-rails', '~> 1.15'
gem 'paper_trail', '~> 14.0'
gem "net-http"
gem 'activemodel-serializers-xml'

# Authentication
gem 'pundit', '~> 2.3.0'
gem 'rack-cas', '~> 0.16.0'
gem 'rest-client', '~> 2.1.0'

# Assets
gem 'coffee-rails', '~> 5.0.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

# View Helpers
# TODO: gem 'activeadmin-axlsx', '>= 2.2' when compatible with activeadmin-1.0.0
# TODO: and remove the version in ./lib/active_admin/
gem 'axlsx', '~> 3.0.0.pre'
gem 'chosen-rails', '~> 1.10.0'
gem 'compass-rails', '~> 4.0'
gem 'countries', '~> 1.2.5'
#gem 'money-rails', '~> 1.13'
gem 'phone', '~> 1.2.3'
gem 'prawn', '~> 2.2'
gem 'prawn-table', '~> 0.2'
gem 'truncate_html', '~> 0.9.3'

# Frontend Scripts
gem 'ckeditor_rails', '~> 4.6'
gem 'intl-tel-input-rails', '~> 8.4.9'
gem 'jquery-rails', '~> 4.5'
gem 'jquery-ui-rails', '~> 6.0'
gem 'turbolinks', '~> 5.0.1'

# Interface with DocuSign
gem 'docusign_rest', '~> 0.4.4'

# We don't require Nokogiri directly, only through other gems (like axlsx).
# However, due to CVE's, we need to ensure we're using a recent version.
gem 'nokogiri', '>= 1.10.3'

group :development, :test do
  gem 'dotenv-rails', '~> 2.8.0'

  # Testing
  gem 'bundler-audit', '~> 0.5'           # Linter
  gem 'capybara-screenshot'
  gem 'coffeelint', '~> 1.16'             # Coffeescript Linter
  gem 'database_cleaner', '~> 1.5'        # Truncates the DB after each test
  gem 'factory_bot', '~> 4.8'            # Test object factories
  gem 'faker', '~> 3.2'                   # Fake data generator
  gem 'guard', '~> 2.14'                  # Continuous testing
  gem 'guard-minitest', '~> 2.4'          # ""
  gem 'letter_opener', '~> 1.7.0'         # Preview email on browser instead of sending
  gem 'm', '~> 1.5.0'                     # Allow to run individual tests
  gem 'minitest', '~> 5.14'
  gem 'minitest-around', '~> 0.5'         # Minitest around callback
  #gem 'minitest-rails-capybara', '~> 2.1' # Integration tests
  gem 'minitest-reporters', '~> 1.1'      # Test output format

  gem 'minitest-rails', '~> 6.0'
  #gem 'minitest-rails-capybara', '~> 3.0'
  gem 'chosen-rails', '~> 1.10.0'
  gem 'capybara'
  gem 'rails-controller-testing'

  gem 'mocha', '~> 1.7.0'                 # Test mocking and stubbing
  gem 'pry-byebug', '~> 3.9.0'            # Debugger
  gem 'pry-rails', '~> 0.3.5'
  gem 'rack_session_access', '~> 0.2.0'     # Edit user-agent session
  gem 'reek', '~> 5.2'                    # Linter
  gem 'rubocop', '~> 0.60'                # Linter
  gem 'selenium-webdriver', '~> 4.4'      # Integration tests javascript support
  gem 'simplecov', '~> 0.15',             # test coverage
      require: false
  gem 'vcr', '~> 6.0.0'                   # Record/Reply HTTP Requests
  gem 'webmock', '~> 3.5'                 # Stub HTTP requests

  # Documentation
  gem 'yard', '~> 0.9.5'
end

group :development do
  # Development Server
  gem 'better_errors'                     # Better Errors
  gem 'binding_of_caller'                 # Better Errors
  gem 'spring', '~>4.1'

  # Disabled web-console due to server error `IPAddr::InvalidAddressError: invalid address`
  # gem 'web-console', '~> 2.0'
end
gem 'awesome_print'
gem 'amazing_print'
#gem 'lograge'
gem 'ougai', '~> 1.7'
gem 'bigdecimal', '< 3'
