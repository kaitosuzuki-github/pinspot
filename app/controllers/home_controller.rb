class HomeController < ApplicationController
  def index
    @posts = Post.select(:id, :title, :description, :location, :latitude, :longitude).order(created_at: :DESC)
  end
end
