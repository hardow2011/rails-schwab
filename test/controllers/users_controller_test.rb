require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @user_password = 'cajeipracrafo'
  end

  test "index should not be found" do
    get users_url
    assert_response :not_found
  end

  test "should get login" do
    get login_url
    assert_response :success
    sign_in_as(@user.email, @user_password)
    get login_url
    assert_redirected_to root_url, message = 'Should have redirected to root after login'
  end

  test "should get signup" do
    get signup_url
    assert_response :success
    sign_in_as(@user.email, @user_password)
    get signup_url
    assert_redirected_to root_url, message = 'Should have redirected to root afetr login'
  end

  test "should create user" do
    assert_difference("User.count") do
      post users_url, params: { user: { email: 'ola@k.ase', password: 'saludos', password_confirmation: 'saludos' } }
    end

    assert_redirected_to root_url
  end

  test "should show user" do
    get user_url
    assert_redirected_to login_url, message = 'Should have redirected to login page'
    sign_in_as(@user.email, @user_password)
    assert_redirected_to root_url, message = 'Should have redirected to root page'
    get user_url
    assert_response :success, 'Should not have show user without login'
  end

  # test "should get edit" do
  #   get edit_user_url(@user)
  #   assert_response :success
  # end
  #
  # test "should update user" do
  #   patch user_url(@user), params: { user: { email: @user.email, password_digest: @user.password_digest } }
  #   assert_redirected_to user_url(@user)
  # end
  #
  # test "should destroy user" do
  #   assert_difference("User.count", -1) do
  #     delete user_url(@user)
  #   end
  #
  #   assert_redirected_to users_url
  # end
end
