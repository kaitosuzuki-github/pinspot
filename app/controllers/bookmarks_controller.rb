class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def create
    unless current_user.bookmarking?(params[:post_id])
      current_user.bookmarks.create(post_id: params[:post_id])
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    if current_user.bookmarking?(params[:post_id])
      bookmark = current_user.bookmarks.find_by(post_id: params[:post_id])
      bookmark.destroy
    end
    redirect_back(fallback_location: root_path)
  end
end
