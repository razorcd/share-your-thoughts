class UsersController < ApplicationController
  before_action :check_login, :except => [:new, :create, :login, :index, :confirm_email, :forgot_password, :reset_forgot_password]

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

  def forgot_password
  end

  def reset_forgot_password
    flash[:forgot_password_errors] = []
    email_regex = Regexp.new(/\A[_a-zA-Z0-9]([\-+_%.a-zA-Z0-9]+)?@([_+\-%a-zA-Z0-9]+)(\.[a-zA-Z0-9]{0,6}){1,2}([a-zA-Z0-9]\z)/i)
    email = params[:user][:email]
    if (email_regex =~ email).nil? 
      flash[:forgot_password_errors] << "Invalid email"
      redirect_to(forgot_password_users_path)
    else
      @user = User.find_by_email(email)
      if @user 
        #reset pass and send:        
        @user.password = random_password(8)
        if @user.save
          UserMailer.forgot_password_email(@user).deliver#send email
          flash[:user_message] = 'Password was reset, please check your email.'
          redirect_to(root_path) #good
        else
          flash[:forgot_password_errors] << "Can't save new password"
          redirect_to(forgot_password_users_path)
        end
      else
        flash[:forgot_password_errors] << "Can't find email in db"
        redirect_to(forgot_password_users_path)
      end
    end
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

end
