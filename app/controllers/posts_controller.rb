class PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    post = Post.new(post_params)
    if post.save
      flash[:notice] = "登録しました"
      redirect_to new_post_path
    else
      flash.now[:notice] = "登録できませんでした"
      render new_post_path
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :description, :location, :latitude, :longitude,:image)
  end
end
