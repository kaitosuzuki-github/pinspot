module PostsHelper
  def create_like_button(post_id)
    unless user_signed_in?
      return render "shared/icons/heart", class_list: "w-8 h-8 fill-none stroke-current"
    end

    if current_user.like?(post_id)
      button_to post_likes_path(post_id), method: :delete do
        render "shared/icons/heart", class_list: "w-8 h-8 fill-current stroke-current"
      end
    else
      button_to post_likes_path(post_id), method: :post do
        render "shared/icons/heart", class_list: "w-8 h-8 fill-none stroke-current"
      end
    end
  end

  def create_bookmark_button(post_id)
    unless user_signed_in?
      return render "shared/icons/bookmark", class_list: "w-8 h-8 fill-none stroke-current"
    end

    if current_user.bookmarking?(post_id)
      button_to post_bookmarks_path(post_id), method: :delete do
        render "shared/icons/bookmark", class_list: "w-8 h-8 fill-current stroke-current"
      end
    else
      button_to post_bookmarks_path(post_id), method: :post do
        render "shared/icons/bookmark", class_list: "w-8 h-8 fill-none stroke-current"
      end
    end
  end
end
