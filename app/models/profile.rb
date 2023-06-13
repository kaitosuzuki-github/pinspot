class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :cover
  has_one_attached :avatar

  validates :cover, attached: true, content_type: ['image/png', 'image/jpeg'],
                    size: { less_than: 15.megabytes },
                    dimension: { width: { min: 400 }, height: { min: 400 } }
  validates :avatar, attached: true, content_type: ['image/png', 'image/jpeg'],
                     size: { less_than: 15.megabytes }
  validates :name, presence: true, length: { maximum: 100 }
  validates :introduction, length: { maximum: 1000 }
end
