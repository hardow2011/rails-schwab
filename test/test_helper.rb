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
    module FunctionalTestsHelper
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

    module SystemTestsHelper
      def get_job_link(job)
        job[:args].last['args'].last
      end

      def login(user)
        visit root_url

        assert_selector 'input[value="Log In"]'

        fill_in 'Email', with: user.email

        perform_enqueued_jobs do
          click_on 'Log In'
        end

        assert_text 'Login email sent. Please check your inbox'

        visit get_job_link(enqueued_jobs.last)

        assert_text 'Summary'
        assert_text '$0'
        assert_text 'Total Value'
      end
    end

    class ActionDispatch::IntegrationTest
      include FunctionalTestsHelper
    end

    class ActionDispatch::SystemTestCase
      include SystemTestsHelper
    end
  end
end
