# Rails Schwab

This project is a passwordless Charles Schwab Bank clone designed to showcase different technologies working together to deliver a simple and stable user experience.

## Table of Contents

- [Installation](#installation)
- [Tests](#tests)
  - [Unit Testing](#unit-testing)
  - [Functional Testing](#functional-testing)
  - [System Testing](#system-testing)
- [Deployment](#deployment)
- [Usage](#usage)
- [Configuration](#configuration)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Installation

* [Install Postgres](https://www.postgresql.org/download/)
  * Setup a Postgres user named”‘schwab” with a password “schwab”
* [Install Redis](https://redis.io/docs/install/install-redis/)
* [Install Ruby](https://github.com/rbenv/rbenv)
* [Install the Ruby on Rails gem](https://guides.rubyonrails.org/getting_started.html#installing-ruby)
* [Install yarn](https://classic.yarnpkg.com/lang/en/docs/install/#debian-stable)
* Clone the repository

## Tests

The testing suite used for Model Testing is MiniTest

### Unit Testing

In our unit tests, the expected behavior of the user model is asserted to confirm the correct data flow and output.  
Examples:
```ruby
  test "should not save user with invalid email" do
    user = User.new(email: 'invemail.com')
    user.save
    assert_includes user.errors[:email], 'is invalid', 'Saved the user with an invalid email'
  end
```
```ruby
  test "transactions csv should set correct amount of transactions" do
    csv = File.open(@test_csv_path)
    @user.set_transactions(csv)
    assert_equal 64, @user.transactions.size, 'Transaction csv should have created 64 transactions'
  end
```
```ruby
  test "transactions chart data should return a correct amount of days " do
    csv_1 = File.open(@test_csv_path)
    csv_2 = File.open(@test_csv_2_path)

    @user.set_transactions(csv_1)
    assert_equal 43, JSON.parse(@user.get_transactions_chart_data).size, 'First transactions csv should have returned a chart data of 43 days'

    @user.set_transactions(csv_2)
    assert_equal 22, JSON.parse(@user.get_transactions_chart_data).size, 'Second transactions csv should have returned a chart data of 22 days'
  end
```

### Functional Testing

In our functional tests, the controllers are asserted to assert the correct responses to given requests.  
Examples:
```ruby
  test "index should not be found" do
    get users_url
    assert_response :not_found
  end
```
```ruby
  test "should show user page" do
    get user_url
    assert_redirected_to login_url(redirect_path: '/user'), message = 'Should have redirected anonymous user to login page'
    login_as(@user)
    assert_redirected_to root_url, message = 'Should have redirected logged in user to root after login'
    get user_url
    assert_response :success, 'Should not have shown user page without login'
  end
```
```ruby
  test "should update user" do
    login_as(@user)
    assert_emails 1 do
      get request_email_change_path
    end
    assert_redirected_to user_url, message = 'Should have redirected to user page after requesting email change'

    email_change_token = JsonWebToken.encode({
                                               email: @user.email,
                                               exp: 1.hour.from_now.to_i
                                             })
    @user.update_column(:email_change_token, email_change_token)

    get change_email_path(email_change_token: @user.email_change_token)
    assert_template 'users/change_email', 'Should have rendered to email update form'

    new_email = 'don@don.com'
    email_update_token = JsonWebToken.encode({
                                               email: @user.email,
                                               exp: 1.hour.from_now.to_i,
                                               new_email: new_email
                                             })
    @user.update_column(:email_change_token, email_update_token)

    patch update_email_path(email_change_token: @user.email_change_token,
                            user: {
                              new_email: new_email,
                              new_email_confirmation: new_email
                            })

    confirm_email_update_token = JsonWebToken.encode({
                                               email: @user.email,
                                               exp: 1.hour.from_now.to_i,
                                               new_email: new_email
                                             })

    @user.update_column(:email_change_token, confirm_email_update_token)

    get confirm_email_update_path(email_update_token: @user.email_change_token)

    assert_includes flash[:success], "Email updated successfully."

    assert_redirected_to root_path, 'Should have redirected to root path'
  end
```

### System Testing

Our system tests are used to validate the final product based on the user perspective.  
Examples:
```ruby
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
```
```ruby
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
```
```ruby
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
```

## Deployment

wip.

## Usage

### Signup and Login

1. The user enters an email to signup  
![Signup window](https://github.com/hardow2011/rails-schwab/assets/45014033/d6916a78-1972-4077-b277-17f96b135c54)

2.  The sign up link is sent to the user's email  
![Signup link](https://github.com/hardow2011/rails-schwab/assets/45014033/5143a02d-5c1a-4529-8b7c-31f2fe8dc61a)

3.  After accessing the signup link, the user is redirected to the app  
![Main page](https://github.com/hardow2011/rails-schwab/assets/45014033/9c32010f-b9a0-4026-8c65-923e6f6c43e7)

### Transactions upload

1. The user accesses the account page
2. Selects a transactions files exported from his Schwab bank
3. Clicks on the "Upload Transactions CSV" button
   ![Account page](https://github.com/hardow2011/rails-schwab/assets/45014033/f5c738b6-894c-4e28-b33b-078cdb95fab1)

### Email update

1. The user accessed the account page
2. The user clicks on the "Change Email" button
3. An email is sent to the user user to proceed with the update
   ![Email change link](https://github.com/hardow2011/rails-schwab/assets/45014033/d130347d-4977-4ed2-8aa2-4147a613ae7a)
4. The user is taken to the email change page to enter his new email
   ![Email change page](https://github.com/hardow2011/rails-schwab/assets/45014033/24719a16-1e25-407b-938a-9e281c47db93)
5. Am email is sent to the new email typed
6. After confirming the email change, it is officially updated
   ![Email confirm link](https://github.com/hardow2011/rails-schwab/assets/45014033/79830fe8-0a64-448e-a12a-7427ec8e5466)

### Email deletion

1. The user accesses the account page
2. Clicks on the "Delete User" button
3. Clicks on the link from the email sent to proceed with the deletion
4. Retypes the current email to confirm the deletion

## Configuration

wip.

## Contact

Contact me at: [louvensraphael@outlook.com](mailto:louvensraphael@outlook.com)
