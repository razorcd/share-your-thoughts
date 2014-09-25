class UsersController < ApplicationController
  before_action :check_login, :except => [:new, :create, :login]

  def new
    if loggedin? then redirect_to user_thoughts_path(session[:user_id]) end
  end

  #POST Register Form
  def create
    @user_register = User.new(user_permits)

    if @user_register.save
      login_user(@user_register)
      redirect_to user_thoughts_path(@user_register.id)
    else
      @user_register.clear_password_fields
      render "new"
    end
  end


  def login
    @user = User.where(:username => user_permits[:username]).first
    if @user && @user.authenticate(user_permits[:password]) 
      login_user(@user)
      redirect_to user_thoughts_path(@user.id)
    else
      @user.clear_password_fields if @user
      redirect_to root_path, :notice => "Wrong username/password"
    end
  end

  def logout
    logout_user
    redirect_to root_path
  end



  private

  def user_permits
    params.require(:user).permit(:full_name, :username, :password, :password_confirmation, :email)
  end

  def login_user(u)
    if ( !u.id ) then raise "Can't login an unsaved user. Missing user ID." end
    session[:user_id] = u.id
    session[:username] = u.username
  end

  def check_login 
    if session[:user_id] then return true end
    logout_user
    redirect_to root_path
  end

  def loggedin?
    if session[:user_id] then return true
    else return false
    end
  end

  def logout_user
    session[:user_id] = nil
    session[:username] = nil
  end
end
