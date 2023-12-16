require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "index should not be found" do
    get users_url
    assert_response :not_found
  end

  test "should send login email" do
    get login_url
    assert_response :success

    assert_enqueued_emails 1 do
      login_as(@user)
    end
  end

  test "should get login" do
    get root_url
    assert_response :redirect, 'Should have redirected anonymous user'
    assert_redirected_to login_url, message = 'Should have redirected anonymous user to login page'
    login_as(@user)
    get login_url
    assert_redirected_to root_url, message = 'Should have redirected logged in user to root after login'
  end

  test "should get redirect path before login" do
    get user_url
    assert_redirected_to login_url(redirect_path: '/user'), message = 'Should have redirected anonymous user to login page'
    get login_url
    assert_response :success, message = 'Should not redirect anonymous user from login page'
  end

  test "should get signup" do
    get signup_url
    assert_response :success
    login_as(@user)
    get signup_url
    assert_redirected_to root_url, message = 'Should have redirected logged in user to root after login'
  end

  test "should create user" do
    assert_difference("User.count") do
      post users_url, params: { user: { email: 'user@user.com' } }
    end

    follow_redirect!

    assert_redirected_to login_url, message = 'Should have redirected to login page after sign up attempt'
  end

  test "should show/edit user" do
    get user_url
    assert_redirected_to login_url(redirect_path: '/user'), message = 'Should have redirected anonymous user to login page'
    login_as(@user)
    assert_redirected_to root_url, message = 'Should have redirected logged in user to root after login'
    get user_url
    assert_response :success, 'Should not have shown user page without login'
  end

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

    email_change_token = JsonWebToken.encode({
                                               email: @user.email,
                                               exp: 1.hour.from_now.to_i
                                             })

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

    assert_redirected_to user_path, 'Should have redirected to user path'
  end

  # test "should destroy user" do
  #   assert_difference("User.count", -1) do
  #     delete user_url(@user)
  #   end
  #
  #   assert_redirected_to users_url
  # end
end
