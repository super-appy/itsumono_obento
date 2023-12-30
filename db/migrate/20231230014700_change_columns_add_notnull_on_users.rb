class ChangeColumnsAddNotnullOnUsers < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :line_registerd, :integer, null: false
  end
end
