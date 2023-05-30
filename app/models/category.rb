class Category < ApplicationRecord
  has_many :post_category_relations, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }

  def self.ransackable_attributes(auth_object)
    ["id"]
  end
end
