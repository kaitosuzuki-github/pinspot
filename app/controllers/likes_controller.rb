class LikesController < ApplicationController
  before_action :limit_user_likes

  def create
    like = Like.new(user_id: current_user.id, post_id: params[:post_id])
    like.save
    redirect_to post_path(params[:post_id])
  end

  def destroy
    like = Like.find_by(user_id: current_user.id, post_id: params[:post_id])
    like.destroy
    redirect_to post_path(params[:post_id])
  end

  private

  def limit_user_likes
    post = Post.find(params[:post_id])
    if post.user_id == current_user.id
      redirect_to post_path(params[:post_id])
    end
  end
end
