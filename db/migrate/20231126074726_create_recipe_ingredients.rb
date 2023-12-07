class CreateRecipeIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :recipe_ingredients do |t|
      t.string :name, null: false
      t.string :quantity, null: false
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end
  end
end
