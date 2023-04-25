class Post < ApplicationRecord
  has_one_attached :image
  belongs_to :user

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :location, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :longitude, presence: true
end
