class Post < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :likes, dependent: :destroy

  validates :image, presence: true
  validates :location, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 1000 }

  def self.ransackable_attributes(auth_object)
    ["location", "title"]
  end

  def self.ransackable_associations(auth_object)
    ["image_attachment", "image_blob", "user"]
  end
end
