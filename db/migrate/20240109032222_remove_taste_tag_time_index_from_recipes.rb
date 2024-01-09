class RemoveTasteTagTimeIndexFromRecipes < ActiveRecord::Migration[7.0]
  def change
    remove_index :recipes, :taste_tag_time
  end
end
