class UsersController < ApplicationController
  # def login_form
  #   @user = User.new
  # end

  def index
    @users = User.all
  end

  # Now that we've been redirected back to the Rails app from GitHub,
  # GitHub has given us a present: a bunch of data, in the form of an auth_hash.
  def create
    auth_hash = request.env["omniauth.auth"]

    user = User.find_by(uid: auth_hash[:uid], provider: "github")
    if user
      # User was found in the database
      flash[:success] = "Logged in as returning user #{user.username}"
    else
      # User doesn't match anything in the DB
      # Attempt to create a new user
      # build_from_github helper class method that lives in the model because
      # it is only relevant to Users,and not to controllers.
      user = User.build_from_github(auth_hash)

      if user.save
        flash[:success] = "Logged in as new user #{user.username}"
      else
        # Couldn't save the user for some reason. If we
        # hit this it probably means there's a bug with the
        # way we've configured GitHub. Our strategy will
        # be to display error messages to make future
        # debugging easier.
        flash[:error] = "Could not create new user account: #{user.errors.messages}"
        return redirect_to root_path
      end
    end
    # If we get here, we have a valid user instance
    session[:username] = user.username
    session[:user_id] = user.id
    return redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "Successfully logged out!"

    redirect_to root_path
  end

  # def login
  #   #Find the user get in the form
  #   user = User.find_by(username: params[:user][:username])

  #   if user.nil?
  #     # New user
  #     user = User.create(username: params[:user][:username])
  #     if !user.save
  #       # If i cannot save
  #       flash[:error] = "Unabel to login"
  #       redirect_to root_path
  #       return
  #     end
  #     # If i can "Welcome"
  #     flash[:welcome] = "Welcome #{user.username}"
  #   else
  #     # Existing user
  #     flash[:welcome] = "Welcome back #{user.username}"
  #   end

  #   session[:user_id] = user.id
  #   session[:username] = user.username

  #   redirect_to root_path
  # end

  # def logout
  #   if session[:user_id]
  #     user = User.find_by(id: session[:user_id])
  #     unless user.nil?
  #       session[:user_id] = nil
  #       flash[:notice] = "Goodbye #{user.username}"
  #     else
  #       session[:user_id] = nil
  #       flash[:error] = "You must be logged in to logout"
  #     end
  #   else
  #     flash[:error] = "You must be logged in to logout"
  #   end
  #   redirect_to root_path
  # end

  def current
    @user = User.find_by(id: session[:user_id])
    if @user.nil?
      # I have to be logged in!
      flash[:error] = "You must be logged in to view this page"
      redirect_to root_path
      return
    end
  end

  def show
    user_id = params[:id].to_i
    # It needs to handle this exception.
    @user = User.find_by(id: user_id)

    if @user.nil?
      head :not_found
      return
    end
  end
end
