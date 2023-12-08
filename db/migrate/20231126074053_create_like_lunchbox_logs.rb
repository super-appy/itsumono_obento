class CreateLikeLunchboxLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :like_lunchbox_logs do |t|
      t.references :user, foreign_key: true
      t.references :lunchbox_log, null: false, foreign_key: true

      t.timestamps
    end
  end
end
