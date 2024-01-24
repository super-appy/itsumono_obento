class CreateUserSearchLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :user_search_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :search_params

      t.timestamps
    end
  end
end
