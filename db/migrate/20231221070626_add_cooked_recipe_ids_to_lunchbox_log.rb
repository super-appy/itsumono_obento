class AddCookedRecipeIdsToLunchboxLog < ActiveRecord::Migration[7.0]
  def change
    add_column :lunchbox_logs, :cooked_recipe_ids, :integer
  end
end
