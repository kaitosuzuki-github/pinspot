class ApplicationController < ActionController::Base
  before_action :set_search

  def set_search
    @q = Post.ransack(params[:q])
  end
end
