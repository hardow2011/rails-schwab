require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]


  def login(email, password)
    visit root_url
    fill_in 'Email', with: email
    fill_in 'Password', with: password

    click_on 'Log In'
  end
end
