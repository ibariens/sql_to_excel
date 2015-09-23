class CreateReport < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string     :name
      t.text       :stored_sql
      t.string     :file_name
      t.float      :execution_time
      t.datetime   :last_execution
      t.timestamps
    end

    create_table :owners do |t|
      t.belongs_to :report
      t.belongs_to :user
      t.timestamps
    end
    add_index :owners, [:report_id, :user_id], :unique => true
  end
end
