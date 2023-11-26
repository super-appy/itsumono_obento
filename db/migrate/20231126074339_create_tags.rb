class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      t.integer :category
      t.string :name

      t.timestamps
    end
  end
end
