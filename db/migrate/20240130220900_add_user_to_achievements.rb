class AddUserToAchievements < ActiveRecord::Migration[7.0]
  def change
    add_reference :achievements, :user, null: false, foreign_key: true
  end
end
