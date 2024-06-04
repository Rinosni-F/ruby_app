class CreateUser < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :email, null: false, unique: true
      t.string :password_digest, null: false
      t.string :role, null: false
      t.timestamps null: false
    end
  end

end
