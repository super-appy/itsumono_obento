class CreateLunchboxLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :lunchbox_logs do |t|
      t.date :cooked_date, null: false
      t.string :original_menu
      t.text :comment
      t.string :image
      t.integer :published_status, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
