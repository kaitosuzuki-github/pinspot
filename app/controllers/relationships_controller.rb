class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :limit_user, only: [:create]

  def create
    unless current_user.following?(params[:user_id])
      current_user.follow(params[:user_id])
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    if current_user.following?(params[:user_id])
      current_user.unfollow(params[:user_id])
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def limit_user
    if current_user.same_user?(params[:user_id])
      redirect_back(fallback_location: root_path)
    end
  end
end
