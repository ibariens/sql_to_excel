class CreateSqlFiles < ActiveRecord::Migration
  def change
    create_table :sql_files do |t|
      t.string    :name
      t.string    :directory
      t.timestamp :last_modified
      t.timestamps
    end

    add_column :reports, :sql_file_id, :integer, :null => false
    add_index  :reports, :sql_file_id, :unique => true
  end
end
