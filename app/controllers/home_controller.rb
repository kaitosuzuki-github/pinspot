class HomeController < ApplicationController
  MAX_POSTS_COUNT = 4

  def index
    posts = Post.all
    @posts_json = posts.to_json(only: [:id, :title, :location, :latitude, :longitude])
    @new_posts = Post.with_attached_image.order(created_at: :DESC).limit(MAX_POSTS_COUNT)
  end
end
