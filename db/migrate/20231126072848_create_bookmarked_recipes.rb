class CreateBookmarkedRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :bookmarked_recipes do |t|
      t.integer :status
      t.text :comment
      t.integer :repeat
      t.references :user, null: false, foreign_key: true
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end
  end
end
