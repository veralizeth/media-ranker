ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/rails"
require "minitest/reporters"  # for Colorized output
#  For colorful output!
Minitest::Reporters.use!(
  Minitest::Reporters::SpecReporter.new,
  ENV,
  Minitest.backtrace_filter
)

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors) # causes out of order output.

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def login(username = "new_user_test")
    # Arrange
    user_hash = {
      user: {
        username: username,
      },
    }

    post login_path, params: user_hash

    user = User.find_by(username: username)
    return user
  end

  # # To be able to mock the interaction with Github

  # def setup
  #   # Once you have enabled test mode, all requests
  #   # to OmniAuth will be short circuited to use the mock authentication hash.
  #   # A request to /auth/provider will redirect immediately to /auth/provider/callback.
  #   OmniAuth.config.test_mode = true
  # end

  # # Test helper method to generate a mock auth hash
  # # for fixture data
  # def mock_auth_hash(user)
  #   return {
  #     provider: user.provider,
  #     uid: user.uid,
  #     info: {
  #       email: user.email,
  #       nickname: user.name,
  #     },
  #   }
  # end
end
