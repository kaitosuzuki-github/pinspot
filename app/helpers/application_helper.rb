module ApplicationHelper
  BASE_TITLE = 'Pinspot'.freeze

  def create_title(title_info)
    if title_info.blank?
      BASE_TITLE
    else
      "#{BASE_TITLE} - #{title_info}"
    end
  end

  def create_header_elements
    if user_signed_in?
      render("shared/header_dropdown") +
      link_to("投稿する", new_post_path, class: "new-button")
    else
      button_to("ゲストログイン", users_guest_sign_in_path, method: :post, class: "normal-link") +
      link_to("ログイン", new_user_session_path, class: "normal-link") +
      link_to("新規登録", new_user_registration_path, class: "new-button")
    end
  end

  def is_errors_lat_lng?(attribute)
    attribute == :latitude || attribute == :longitude
  end

  def create_follow_button(user_id)
    if user_signed_in? && current_user.following?(user_id)
      button_to "フォロー中", user_relationships_path(user_id),
      method: :delete, data: { turbo_confirm: 'フォローをやめますか?' },
      class: "follow-button"
    else
      button_to "フォローする", user_relationships_path(user_id), class: "follow-button"
    end
  end

  # 引数のsizeはsmall、medium、largeから選ぶ
  def select_image_preview(image, size)
    if image.attached?
      image.variant(resize_to_limit: select_image_size(size))
    else
      ""
    end
  end

  # 引数のsizeはsmall、medium、largeから選ぶ
  def select_image_size(size)
    case size
    when "avatar"
      [100, 100]
    when "small"
      [500, 500]
    when "medium"
      [1000, 1000]
    when "large"
      [1500, 1500]
    end
  end

  # 引数のsizeはsmall、medium、largeから選ぶ
  def create_avatar_elements(avatar, size)
    tag.div class: "#{size} rounded-full overflow-hidden" do
      if avatar.attached?
        image_tag avatar.variant(resize_to_limit: select_image_size("avatar")), class: "w-full h-full object-cover"
      else
        render "shared/icons/user", class_list: "#{size} fill-current"
      end
    end
  end

  def create_ham_menu_list
    if user_signed_in?
      render "shared/hamburger_menu_list_sign_in"
    else
      render "shared/hamburger_menu_list_sign_out"
    end
  end
end
