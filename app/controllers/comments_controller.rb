class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :limit_user!, only: [:destroy]

  def create
    comment = Comment.new(comment_params)
    comment.post_id = params[:post_id]
    comment.user_id = current_user.id
    comment.save
    redirect_back(fallback_location: root_path)
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def limit_user!
    comment = Comment.find(params[:id])
    unless current_user.same_user?(comment.user_id)
      redirect_back(fallback_location: root_path)
    end
  end
end
