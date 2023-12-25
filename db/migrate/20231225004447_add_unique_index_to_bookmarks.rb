class AddUniqueIndexToBookmarks < ActiveRecord::Migration[7.0]
  def change
    add_index :like_lunchbox_logs, [:user_id, :lunchbox_log_id], unique: true
  end
end
