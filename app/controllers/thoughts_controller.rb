require_relative "concerns/controller_helpers.rb"

class ThoughtsController < ApplicationController
  before_action :check_login, :check_current_user, :except => [:index]

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

  include CONTROLLER_HELPERS

  def thought_permits
    params.require(:thought).permit(:title, :body, :shout)
  end

end
