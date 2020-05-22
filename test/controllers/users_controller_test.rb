require "test_helper"

describe UsersController do
  it "must get login_form" do
    get login_path
    must_respond_with :success
  end
  describe "must get login" do
    it "can log in an existing user and flashes a message" do
      login_data = {
        user: {
          username: "vera",
        },
      }

      expect { post login_path, params: login_data }.wont_change "User.count"

      existing_user = User.find_by(username: "vera")

      expect(session[:user_id]).must_equal existing_user.id
      expect(flash[:welcome]).must_equal "Welcome back #{existing_user.username}"
    end
  end

  it "can create a new user and flashes a message" do
    user = nil
    expect {
      user = login()
    }.must_differ "User.count", 1

    must_respond_with :redirect

    expect(user).wont_be_nil
    expect(session[:user_id]).must_equal user.id
    expect(user.username).must_equal "new_user_test"
    expect(flash[:welcome]).must_equal "Welcome #{user.username}"
  end

  describe "logout" do
    it "successfully logs a valid user out" do
      login()
      expect(session[:user_id]).wont_be_nil

      # Act

      post logout_path

      expect(session[:user_id]).must_be_nil
    end

    it "redirects to root path if no user is logged in" do
      post logout_path

      must_redirect_to root_path
    end
  end

  describe "current user" do
    it "can return the page if the user is logged in " do
      #Arrage
      login()
      #Act
      get current_user_path

      #Assert
      must_respond_with :success
    end

    it "redirects us back if the user is not logged in" do
      #Act
      get current_user_path

      #Assert
      must_respond_with :redirect

      expect(flash[:error].must_equal "You must be logged in to view this page")
    end
  end
end
