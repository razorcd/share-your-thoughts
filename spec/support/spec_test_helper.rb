
module SpecTestHelper   
  def login(username)
    user = User.where(:username => username).first #if user.is_a?(Symbol)
    session[:user_id] = user.id
    session[:username] = user.username
  end

  def loggedin_user
    User.find(request.session[:user_id])
  end
end