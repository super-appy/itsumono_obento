class CreateRecipeSteps < ActiveRecord::Migration[7.0]
  def change
    create_table :recipe_steps do |t|
      t.integer :number, null: false
      t.text :description, null: false
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end
  end
end
