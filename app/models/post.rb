class Post < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :post_category_relations, dependent: :destroy
  has_many :categories, through: :post_category_relations
  has_many :comments, dependent: :destroy

  validates :image, presence: true
  validates :location, presence: true, length: { maximum: 255 }
  validates :latitude, numericality: true
  validates :longitude, numericality: true
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 1000 }

  def self.ransackable_attributes(auth_object)
    ["location", "title", "created_at"]
  end

  def self.ransackable_associations(auth_object)
    ["categories"]
  end
end
