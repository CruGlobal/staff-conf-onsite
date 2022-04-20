require 'selenium/webdriver'

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  capabilities =
    Selenium::WebDriver::Remote::Capabilities.chrome(
      chromeOptions: { args: %w(headless disable-gpu disable-dev-shm-usage no-sandbox window-size=3840,21600 remote-debugging-port=9222) }
    )

  options = Selenium::WebDriver::Chrome::Options.new

  options.add_argument('--headless')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-gpu')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--remote-debugging-port=9515')
  options.add_argument('--window-size=3840,21600')
  
  #Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: capabilities, options: options)
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara::Screenshot.register_driver(:headless_chrome) do |driver, path|
  driver.browser.save_screenshot(path)
end

Capybara.javascript_driver =
  if ENV.key?('CAPYBARA_DRIVER')
    ENV['CAPYBARA_DRIVER'].to_sym
  else
    :headless_chrome
  end
