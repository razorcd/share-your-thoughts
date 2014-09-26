class UsersController < ApplicationController
  before_action :check_login, :except => [:new, :create, :login]

  def new
    # if loggedin? then redirect_to user_thoughts_path(session[:user_id]) end
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

  def edit
    @current_user = User.find(session[:user_id])
  end

  def update
    @current_user = User.find(session[:user_id])
    if @current_user
      @current_user.full_name = user_permits[:full_name]
      @current_user.username = user_permits[:username]
      @current_user.email = user_permits[:email]
      if @current_user.authenticate(user_permits[:password]) 
        #TODO: add email_confiemed = false  ? to confirm email again
        @current_user.save  #will add the error messages if save failed to @current_user.errors.full_messages
      else
        @current_user.errors[:password] << "is wrong"
      end
    end
    flash[:edit_user_errors] = @current_user.errors.full_messages
    #redirect_to edit_user_path(session[:user_id])
    render "edit"
  end

  private

  include CONTROLLER_HELPERS

  def user_permits
    params.require(:user).permit(:full_name, :username, :password, :password_confirmation, :email)
  end


end
