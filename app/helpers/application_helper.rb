module ApplicationHelper
  # 引数のsizeはsmall、medium、largeから選ぶ
  def display_avatar(avatar, size:)
    case size
    when "small"
      avatar_size = "w-8 h-8"
    when "medium"
      avatar_size = "w-10 h-10"
    when "large"
      avatar_size = "w-14 h-14"
    end

    if avatar.attached?
      tag.div class: "#{avatar_size} rounded-full overflow-hidden" do
        image_tag avatar.variant(resize_to_limit: [100, 100]), class: "w-full h-full object-cover"
      end
    else
      render "shared/icons/user", class_list: "#{avatar_size} fill-current"
    end
  end
end
