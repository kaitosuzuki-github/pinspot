class ProfilesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :limit_user, only: [:edit, :update, :show_bookmarks]

  def show
    @profile = Profile.find(params[:id])
    @posts = @profile.user.posts.with_attached_image
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
      render :edit, status: :unprocessable_entity
    end
  end

  def show_likes
    @profile = Profile.find(params[:id])
    @like_posts = @profile.user.like_posts.with_attached_image
  end

  def show_bookmarks
    @profile = Profile.find(params[:id])
    @bookmark_posts = @profile.user.bookmark_posts.with_attached_image
  end

  def followers
    @users = Profile.preload(user: [followers: [profile: [avatar_attachment: :blob]]]).find(params[:id]).user.followers
  end

  def following
    @users = Profile.preload(user: [followings: [profile: [avatar_attachment: :blob]]]).find(params[:id]).user.followings
  end

  private

  def profile_params
    params.require(:profile).permit(:name, :introduction, :cover, :avatar)
  end

  def limit_user
    profile = Profile.find(params[:id])
    unless current_user.same_user?(profile.user_id)
      redirect_back(fallback_location: root_path)
    end
  end
end
