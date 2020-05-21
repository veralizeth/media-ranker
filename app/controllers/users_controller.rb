class UsersController < ApplicationController

  def login_form
    @user = User.new
  end

  def index
    @users = User.all
  end

  def login
    #Find the user get in the form
    user = User.find_by(username: params[:user][:username])

    if user.nil?
      # New user
      user = User.create(username: params[:user][:username])
      if !user.save
        # If i cannot save
        flash[:error] = "Unabel to login"
        redirect_to root_path
        return
      end
      # If i can "Welcome"
      flash[:welcome] = "Welcome #{user.username}"
    else
      # Existing user
      flash[:welcome] = "Welcome back #{user.username}"
    end

    session[:user_id] = user.id
    session[:username] = user.username

    redirect_to root_path
  end

  def logout
    if session[:user_id]
      user = User.find_by(id: session[:user_id])
      unless user.nil?
        session[:user_id] = nil
        flash[:notice] = "Goodbye #{user.username}"
      else
        session[:user_id] = nil
        flash[:error] = "You must be logged in to logout"
      end
    else
      flash[:error] = "You must be logged in to logout"
    end
    redirect_to root_path
  end

  def current
    @user = User.find_by(id: session[:user_id])
    if @user.nil?
      # I have to be logged in!
      flash[:error] = "You must be logged in to view this page"
      redirect_to root_path
      return
    end
  end
end
