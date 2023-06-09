class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :search]
  before_action :limit_user, only: [:edit, :update, :destroy]

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:notice] = "投稿しました"
      redirect_to @post
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = "変更しました"
      redirect_to @post
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to root_path
  end

  def search
    @posts = @q.result(distinct: true).includes(:categories)
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
      category_ids: []
    )
  end

  def limit_user
    post = Post.find(params[:id])
    unless current_user.same_user?(post.user_id)
      redirect_back(fallback_location: root_path)
    end
  end
end
