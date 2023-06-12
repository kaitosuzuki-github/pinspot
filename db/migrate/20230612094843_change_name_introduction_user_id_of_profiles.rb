class ChangeNameIntroductionUserIdOfProfiles < ActiveRecord::Migration[7.0]
  def change
    change_column_null :profiles, :name, false
    change_column_null :profiles, :introduction, false
    change_column_default :profiles, :introduction, ""
    remove_index :profiles, :user_id
    add_index :profiles, :user_id, unique: true
  end
end
