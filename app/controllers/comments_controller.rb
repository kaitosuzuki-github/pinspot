class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :limit_user, only: [:destroy]

  def create
    Comment.create(comment_params)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def comment_params
    params.require(:comment).permit(:content).merge(post_id: params[:post_id], user_id: current_user.id)
  end

  def limit_user
    comment = Comment.find(params[:id])
    unless current_user.same_user?(comment.user_id)
      redirect_back(fallback_location: root_path)
    end
  end
end
