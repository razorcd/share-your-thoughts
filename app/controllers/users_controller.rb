class UsersController < ApplicationController
  before_action :check_login, :except => [:new, :create, :login, :index, :confirm_email]

  def index
    @users = User.all
  end

  def new
    # if loggedin? then redirect_to user_thoughts_path(session[:user_id]) end
    @allthoughts = Thought.all.sort {|x,y| x.created_at <=> y.created_at}.reverse
  end

  #POST Register Form
  def create
    @user_register = User.new(user_permits)

    if @user_register.save
      UserMailer.welcome_email(@user_register).deliver #send email
      login_user(@user_register) #login
      redirect_to user_thoughts_path(@user_register.id)
    else
      @user_register.clear_password_fields
      flash[:register_error] = @user_register.errors.full_messages 
      redirect_to root_path
      # render "new"
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
      if @current_user.email != user_permits[:email]    #if email changed too
        send_email_confirmation = true
        @current_user.email_confirmed = false
      else 
        send_email_confirmation = false
      end
      @current_user.full_name = user_permits[:full_name]
      @current_user.username = user_permits[:username]
      @current_user.email = user_permits[:email]
      
      if @current_user.authenticate(user_permits[:password]) 
        if @current_user.save  #will add the error messages if save failed to @current_user.errors.full_messages
          if send_email_confirmation then UserMailer.email_confirmation_email(@current_user).deliver end  #send email
          flash[:user_message] = "Details changed"
        end  
      else
        @current_user.errors[:password] << "is wrong"
      end
    end

    flash[:edit_user_errors] = @current_user.errors.full_messages
    #redirect_to edit_user_path(session[:user_id])
    render "edit"
  end

  def change_password
    passwords = params[:user]
    flash[:edit_password_errors] = [] #set flash messages as array
    @current_user = User.find(session[:user_id])
    if @current_user.authenticate(passwords[:old_password])  #confirm old password
      if passwords[:password].empty? then flash[:edit_password_errors] << "Enter new password and confirmation" end
        @current_user.password = passwords[:password]
        @current_user.password_confirmation = passwords[:password_confirmation]
        if @current_user.save && !passwords[:password].empty? then flash[:user_message] = "Password changed" end
    else
      flash[:edit_password_errors] << "Wrong old password"
    end
    flash[:edit_password_errors].concat(@current_user.errors.full_messages)
    redirect_to edit_user_path(session[:user_id])
  end


  def resend_email
    @user = User.find_by_id(session[:user_id])
    if @user 
      UserMailer.email_confirmation_email(@user).deliver #send email
      flash[:user_message] = "Confirmation email sent"
    elsif
      flash[:email_sent_errors] = "Error finding user"
    end
    redirect_to edit_user_path(session[:user_id])
  end

  def confirm_email
    user = User.find_by_id(params[:id])

    flash[:user_message] = "Email already confirmed" if user.email_confirmed == true
    if user && user.email == params[:email] && user.email_confirmed == false
      user[:email_confirmed] = true
      user.save ? flash[:user_message] = "Email confirmed" : flash[:user_message] = "Email failed to confirmed"
    end
    redirect_to root_path
  end



  private

  include CONTROLLER_HELPERS

  def user_permits
    params.require(:user).permit(:full_name, :username, :password, :password_confirmation, :email)
  end

  # def password_permits
  #   params.permit(:old_password, :password, :password_confirmation)
  # end

end
