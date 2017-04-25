class CreateApiUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :api_users do |t|
      t.string :name
      t.string :email
      t.string :password_digest

      t.timestamps
    end
    add_index :api_users, :email
  end
end
