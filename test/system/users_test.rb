require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
  end

  test "should redirect to login page" do
    visit root_url
    assert_selector 'input[value="Log In"]'
  end

  test 'should sign up new user' do
    visit signup_url

    fill_in 'Email', with: 'qwerty@yahoo.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'

    click_on 'Sign Up'

    assert_text 'Summary'
    assert_text '$0'
    assert_text 'Total Value'
  end

  test 'should redirect to transactions chart after logging in existing user' do
    login(@user.email, 'cajeipracrafo')
    assert_text 'Summary'
  end

  # test "should create user" do
  #   visit users_url
  #   click_on "New user"
  #
  #   fill_in "Email", with: @user.email
  #   fill_in "Password digest", with: @user.password_digest
  #   click_on "Create User"
  #
  #   assert_text "User was successfully created"
  #   click_on "Back"
  # end

  # test "should update User" do
  #   visit user_url(@user)
  #   click_on "Edit this user", match: :first
  #
  #   fill_in "Email", with: @user.email
  #   fill_in "Password digest", with: @user.password_digest
  #   click_on "Update User"
  #
  #   assert_text "User was successfully updated"
  #   click_on "Back"
  # end

  # test "should destroy User" do
  #   visit user_url(@user)
  #   click_on "Destroy this user", match: :first
  #
  #   assert_text "User was successfully destroyed"
  # end
end
