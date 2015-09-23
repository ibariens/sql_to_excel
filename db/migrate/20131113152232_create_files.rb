class CreateFiles < ActiveRecord::Migration
  def change
    create_table :file_names do |t|
      t.belongs_to :report
      t.belongs_to :user
      t.string     :last_file_name
      t.timestamps
    end

    add_index :file_names, [:report_id, :user_id], :unique => true
  end
end
