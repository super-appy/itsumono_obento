class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      t.integer :category, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
