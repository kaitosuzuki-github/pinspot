module PostsHelper
  def create_like_button(post_id)
    if user_signed_in? && current_user.like?(post_id)
      button_to post_likes_path(post_id), method: :delete do
        render "shared/icons/heart", class_list: "icon-medium fill-current stroke-current"
      end
    else
      button_to post_likes_path(post_id), method: :post do
        render "shared/icons/heart", class_list: "icon-medium fill-none stroke-current"
      end
    end
  end

  def create_bookmark_button(post_id)
    if user_signed_in? && current_user.bookmarking?(post_id)
      button_to post_bookmarks_path(post_id), method: :delete do
        render "shared/icons/bookmark", class_list: "icon-medium fill-current stroke-current"
      end
    else
      button_to post_bookmarks_path(post_id), method: :post do
        render "shared/icons/bookmark", class_list: "icon-medium fill-none stroke-current"
      end
    end
  end
end
