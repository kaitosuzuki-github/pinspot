module ApplicationHelper
  def is_errors_lat_lng?(attribute)
    attribute == :latitude || attribute == :longitude
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
  def select_avatar_size(size)
    case size
    when "small"
      "w-8 h-8"
    when "medium"
      "w-10 h-10"
    when "large"
      "w-14 h-14"
    end
  end

  # 引数のsizeはsmall、medium、largeから選ぶ
  def create_avatar_elements(avatar, size)
    tag.div class: "#{select_avatar_size(size)} rounded-full overflow-hidden" do
      if avatar.attached?
        image_tag avatar.variant(resize_to_limit: select_image_size("avatar")), class: "w-full h-full object-cover"
      else
        render "shared/icons/user", class_list: "#{select_avatar_size(size)} fill-current"
      end
    end
  end
end
