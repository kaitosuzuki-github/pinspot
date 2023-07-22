require 'capybara/rspec'

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium, using: :headless_chrome, options: {
      browser: :remote,
      url: "http://chrome:4444/wd/hub",
    }
    Capybara.server_host = 'web'
    Capybara.app_host = 'http://web'
  end
end
