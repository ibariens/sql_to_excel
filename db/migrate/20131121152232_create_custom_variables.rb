class CreateCustomVariables < ActiveRecord::Migration
  def change
    create_table :custom_variables do |t|
      t.string     :name
      t.text       :stored_sql
      t.timestamps
    end

    add_index :custom_variables, [:name], :unique => true
  end
end
