class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :crypted_password
      t.string :name
      t.string :avator
      t.integer :line_registerd

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
