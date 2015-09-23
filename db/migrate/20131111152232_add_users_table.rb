class AddUsersTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string    :username
      t.string    :display_name
      t.string    :password_hash
      t.string    :password_salt
      t.integer   :hierarchy
      t.timestamps
    end
  end
end
