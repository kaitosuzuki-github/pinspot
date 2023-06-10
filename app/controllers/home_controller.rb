class HomeController < ApplicationController
  def index
    posts = Post.all
    @posts_json = posts.to_json(only: [:title, :location, :latitude, :longitude])
    @new_posts = Post.with_attached_image.order(created_at: :DESC).limit(4)
  end
end
