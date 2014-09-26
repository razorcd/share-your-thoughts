module CONTROLLER_HELPERS

  def check_login 
    if session[:user_id] then return true end
    logout_user
    redirect_to root_path
  end

  def check_current_user
    redirect_to user_thoughts_path(session[:user_id]) if params[:user_id].to_s != session[:user_id].to_s
  end

  def logout_user
    session[:user_id] = nil
    session[:username] = nil
  end 

  def login_user(u)
    if ( !u.id ) then raise "Can't login an unsaved user. Missing user ID." end
    session[:user_id] = u.id
    session[:username] = u.username
  end

  def loggedin?
    if session[:user_id] then return true
    else return false
    end
  end

end