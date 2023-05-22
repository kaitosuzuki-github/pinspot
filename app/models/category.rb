class Category < ApplicationRecord
  has_many :post_category_relations, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }
end
