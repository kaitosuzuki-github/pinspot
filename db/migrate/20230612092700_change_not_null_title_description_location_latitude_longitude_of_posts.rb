class ChangeNotNullTitleDescriptionLocationLatitudeLongitudeOfPosts < ActiveRecord::Migration[7.0]
  def change
    change_column_null :posts, :title, false
    change_column_default :posts, :title, ""
    change_column_null :posts, :description, false
    change_column_default :posts, :description, ""
    change_column_null :posts, :location, false
    change_column_null :posts, :latitude, false
    change_column_null :posts, :longitude, false
  end
end
