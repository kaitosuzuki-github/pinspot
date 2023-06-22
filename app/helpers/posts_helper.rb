module PostsHelper
  def change_image_preview(post)
    case controller.action_name
    when "new"
      ""
    when "edit"
      post.image.variant(resize_to_limit: [1000, 1000])
    end
  end

  def display_like_button(post_id)
    if user_signed_in?
      if current_user.like?(post_id)
        button_to post_likes_path(post_id), method: :delete do
          render "shared/icons/heart", class_list: "w-8 h-8 fill-current stroke-current"
        end
      else
        button_to post_likes_path(post_id), method: :post do
          render "shared/icons/heart", class_list: "w-8 h-8 fill-none stroke-current"
        end
      end
    else
      render "shared/icons/heart", class_list: "w-8 h-8 fill-none stroke-current"
    end
  end

  def display_bookmark_button(post_id)
    if user_signed_in?
      if current_user.bookmarking?(post_id)
        button_to post_bookmarks_path(post_id), method: :delete do
          render "shared/icons/bookmark", class_list: "w-8 h-8 fill-current stroke-current"
        end
      else
        button_to post_bookmarks_path(post_id), method: :post do
          render "shared/icons/bookmark", class_list: "w-8 h-8 fill-none stroke-current"
        end
      end
    else
      render "shared/icons/bookmark", class_list: "w-8 h-8 fill-none stroke-current"
    end
  end
end
