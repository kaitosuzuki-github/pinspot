class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @profile = Profile.find(params[:id])
    @posts = current_user.posts
  end

  def edit
    @profile = Profile.find(params[:id])
  end

  def update
    @profile = Profile.find(params[:id])
    if @profile.update(profile_params)
      flash[:notice] = "変更しました"
      redirect_to @profile
    else
      flash.now[:notice] = "変更できませんでした"
      render :edit, status: :unprocessable_entity
    end
  end

  def show_likes
    @profile = Profile.find(params[:id])
    @posts = current_user.like_posts
    render :show
  end

  def show_bookmarks
    @profile = Profile.find(params[:id])
    @posts = current_user.bookmark_posts
    render :show
  end

  def followers
    @users = Profile.find(params[:id]).user.followers
  end

  def following
    @users = Profile.find(params[:id]).user.followings
    render :followers
  end

  private

  def profile_params
    params.require(:profile).permit(:name, :introduction, :cover, :avatar)
  end
end
