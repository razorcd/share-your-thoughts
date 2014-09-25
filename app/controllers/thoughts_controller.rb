class ThoughtsController < ApplicationController
  before_action :check_login, :check_current_user

  def create
    @thought = Thought.new(thought_permits)
    @thought.user_id = session[:user_id]

    if @thought.save
      redirect_to user_thoughts_path(session[:user_id])
    else
      # flash[:thought_errors] = @thought.errors.full_messages
      render "index"
    end
  end

  def index
  end

  private

  def thought_permits
    params.require(:thought).permit(:title, :body, :shout)
  end

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

end
