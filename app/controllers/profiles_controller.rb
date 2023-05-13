class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @profile = Profile.find(params[:id])
    @posts = current_user.posts
  end
end
