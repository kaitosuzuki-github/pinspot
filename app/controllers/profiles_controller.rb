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

  private

  def profile_params
    params.require(:profile).permit(:name, :introduction, :cover, :avatar)
  end
end
