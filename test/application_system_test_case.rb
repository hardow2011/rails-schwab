require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  setup do
    # Make sure to set Rails host and port to whatever Capybara's host and port are when running the system tests
    Rails.application.routes.default_url_options[:host] = Capybara.current_session.server.host
    Rails.application.routes.default_url_options[:port] = Capybara.current_session.server.port
  end

  def login(email, password)
    visit root_url
    fill_in 'Email', with: email
    fill_in 'Password', with: password

    click_on 'Log In'
  end
end
