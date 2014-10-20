require_relative "concerns/controller_helpers.rb"

class RelationsController < ApplicationController
  before_action :check_login, :check_current_user

  def follow
    rel = Relation.new
    rel.follower_id = params[:user_id].to_i
    rel.followee_id = params[:id].to_i
    rel.save
    redirect_to users_path
  end

  def unfollow
    Relation.delete_all(:follower_id => params[:user_id].to_i, :followee_id => params[:id].to_i)
    redirect_to users_path
  end

  private 

  include CONTROLLER_HELPERS

end