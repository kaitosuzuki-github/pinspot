class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    unless current_user.like?(params[:post_id])
      current_user.likes.create(post_id: params[:post_id])
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    if current_user.like?(params[:post_id])
      like = current_user.likes.find_by(post_id: params[:post_id])
      like.destroy
    end
    redirect_back(fallback_location: root_path)
  end
end
