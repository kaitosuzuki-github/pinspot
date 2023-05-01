class Post < ApplicationRecord
  has_one_attached :image
  belongs_to :user

  validates :image, presence: true
  validates :location, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 1000 }
end
