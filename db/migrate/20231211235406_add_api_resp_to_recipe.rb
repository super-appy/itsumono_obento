class AddApiRespToRecipe < ActiveRecord::Migration[7.0]
  def change
    add_column :recipes, :api_resp, :text
  end
end
