class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    Comment.create(comment_params)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    comment = Comment.find(params[:id])
    if current_user.same_user?(comment.user_id)
      comment.destroy
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def comment_params
    params.require(:comment).permit(:content).merge(post_id: params[:post_id], user_id: current_user.id)
  end
end
