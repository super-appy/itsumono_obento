class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.string :title, null: false
      t.integer :time_required, null: false
      t.integer :taste, null: false
      t.text :api_ingredients
      t.text :api_steps
      t.string :taste_tag_time, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :recipes, :taste_tag_time, unique: true
  end
end
