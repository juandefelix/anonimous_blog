class CreateUsers < ActiveRecord::Migration
  def change
    add_column :posts, :user_id, :integer

    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_hash
      t.timestamps
    end
  end
end
