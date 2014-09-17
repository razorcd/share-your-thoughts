class ThoughtsController < ApplicationController

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
    if session[:user_id] != nil 
      @user = User.find(session[:user_id]) 
    else
      redirect_to root_url
    end
  end

  private

  def thought_permits
    params.require(:thought).permit(:title, :body, :shout)
  end

end
