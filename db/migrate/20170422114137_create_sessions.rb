class CreateSessions < ActiveRecord::Migration[5.0]
  def change
    create_table :sessions do |t|
      t.text :token
      t.references :api_user, foreign_key: true

      t.timestamps
    end
  end
end
