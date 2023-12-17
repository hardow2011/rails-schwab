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
      def login_as(user, redirect_path = nil)
        params = { email: user.email, commit: 'Log In' }
        params[:redirect_path] = redirect_path if redirect_path
        post authenticate_path, params: params
        get sessions_path, params: { login_token: JsonWebToken.encode({
                                                                                   email: user.email,
                                                                                   exp: 1.hour.from_now.to_i
                                                                      }) }
      end
    end

    module SystemTestHelper
      def get_job_link(job)
        job[:args].last['args'].last
      end
    end

    class ActionDispatch::IntegrationTest
      include SignInHelper
    end

    class ActionDispatch::SystemTestCase
      include SystemTestHelper
    end
  end
end
