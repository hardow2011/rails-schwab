ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    module SignInHelper
      def sign_in_as(user, password)
        post sessions_url, params: { email: @user.email, password: @user_password }
      end
    end

    class ActionDispatch::IntegrationTest
      include SignInHelper
    end
  end
end
