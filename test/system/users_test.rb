require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper
  setup do
    @user = users(:one)
  end

  test "should login user" do
    login(@user)
  end

  test 'should sign up new user' do
    visit signup_url

    assert_selector 'input[value="Sign Up"]'

    fill_in 'Email', with: 'qwerty@yahoo.com'

    perform_enqueued_jobs do
      click_on 'Sign Up'
    end

    assert_text 'Signup email sent. Please check your inbox'

    assert_selector 'input[value="Log In"]'

    visit get_job_link(enqueued_jobs.last)

    assert_text 'Summary'
    assert_text '$0'
    assert_text 'Total Value'
  end

  test 'should redirect to user page' do
    visit user_url

    assert_selector 'input[value="Log In"]'

    fill_in 'Email', with: @user.email

    perform_enqueued_jobs do
      click_on 'Log In'
    end

    assert_text 'Login email sent. Please check your inbox'

    visit get_job_link(enqueued_jobs.last)

    assert_text 'You currently have 0 transactions in total.'

    assert_selector 'a[href="/request_email_change"]'
    assert_selector 'input[type="submit"][value="Upload Transactions CSV"]'
  end

  test "should update User" do
    login(@user)

    visit user_url

    assert_text 'You currently have 0 transactions in total.'

    assert_selector 'a[href="/request_email_change"]'
    assert_selector 'input[type="submit"][value="Upload Transactions CSV"]'

    perform_enqueued_jobs do
      click_on 'Change Email'
    end

    # Without the sleep, the email change job doesn't get added in time for visit get_job_link(enqueued_jobs.last).
    # Not sure why
    sleep 0.1

    visit get_job_link(enqueued_jobs.last)

    fill_in 'user[new_email]', with: 'new@email.com'
    fill_in 'user[new_email_confirmation]', with: 'new@email.com'

    perform_enqueued_jobs do
      click_on 'Change Email'
    end

    # Without the sleep, the email change job doesn't get added in time for visit get_job_link(enqueued_jobs.last).
    # Not sure why
    sleep 0.1

    visit get_job_link(enqueued_jobs.last)

    assert_text 'Email updated successfully'

    assert_text 'Summary'
    assert_text '$0'
    assert_text 'Total Value'
  end
end
