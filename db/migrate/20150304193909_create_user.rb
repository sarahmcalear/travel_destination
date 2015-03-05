class CreateUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :fname
      t.string :lname
      t.string :email, uniqueness: true
      t.string :password_digest

      t.timestamps
    end
  end
end
