class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :cover
  has_one_attached :avatar

  validates :name, presence: true, length: { maximum: 100 }
  validates :introduction, length: { maximum: 1000 }
end
