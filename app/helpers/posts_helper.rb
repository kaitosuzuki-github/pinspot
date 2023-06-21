module PostsHelper
  def change_image_preview(post)
    case controller.action_name
    when "new"
      ""
    when "edit"
      post.image.variant(resize_to_limit: [1000, 1000])
    end
  end
end
