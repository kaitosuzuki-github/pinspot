class PostsController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :limit_current_user, only: %i[edit update destroy]

  def show
    @post = Post.find(params[:id])
    @user = @post.user
  end

  def new
    @post = Post.new
  end

  def create
    post = Post.new(post_params)
    post.user_id = current_user.id
    if post.save
      flash[:notice] = "登録しました"
      redirect_to new_post_path
    else
      flash.now[:notice] = "登録できませんでした"
      render new_post_path
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    post = Post.find(params[:id])
    if post.update(post_params)
      flash[:notice] = "変更しました"
      redirect_to post_path
    else
      render edit_post_path
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to root_path
  end

  private

  def post_params
    params.require(:post).permit(
      :title,
      :description,
      :location,
      :latitude,
      :longitude,
      :image,
    )
  end

  def limit_current_user
    if Post.find(params[:id]).user_id != current_user.id
      flash[:notice] = "アクセスできません"
      redirect_to post_path
    end
  end
end
