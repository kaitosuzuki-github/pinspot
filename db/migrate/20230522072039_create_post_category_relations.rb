class CreatePostCategoryRelations < ActiveRecord::Migration[7.0]
  def change
    create_table :post_category_relations do |t|
      t.references :post, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
      t.index [:post_id, :category_id], unique: true
    end
  end
end
