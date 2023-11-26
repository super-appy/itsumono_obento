class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.string :title
      t.integer :time_required
      t.integer :taste
      t.text :api_ingredients
      t.text :api_steps
      t.string :taste_tag_time
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :recipes, :taste_tag_time, unique: true
  end
end
