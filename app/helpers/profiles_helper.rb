module ProfilesHelper
  def create_posts_tab
    link_to profile_path, class: "flex gap-1 items-center #{set_tab_color("show")}" do
      render("shared/icons/posts", class_list: "w-4 h-4 fill-current") +
      tag.p("投稿")
    end
  end

  def create_likes_tab
    unless user_signed_in?
      return
    end

    link_to show_likes_profile_path, class: "flex gap-1 items-center #{set_tab_color("show_likes")}" do
      render("shared/icons/heart", class_list: "w-4 h-4 fill-current") +
      tag.p("いいねした投稿")
    end
  end

  def create_bookmarks_tab(user_id)
    unless user_signed_in?
      return
    end

    unless current_user.same_user?(user_id)
      return
    end

    link_to show_bookmarks_profile_path, class: "flex gap-1 items-center #{set_tab_color("show_bookmarks")}" do
      render("shared/icons/bookmark", class_list: "w-4 h-4 fill-current") +
      tag.p("保存した投稿")
    end
  end

  def set_tab_color(action_name)
    if controller.action_name == action_name
      ""
    else
      "text-gray-500"
    end
  end
end
