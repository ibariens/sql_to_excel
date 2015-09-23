class AddGroups < ActiveRecord::Migration
  def self.up
    create_table :groups_reports do |t|
      t.belongs_to :report
      t.belongs_to :group
      t.timestamps
    end
    add_index :groups_reports, [:report_id, :group_id], :unique => true



    create_table :groups do |t|
      t.string :name, :unique => true
      t.timestamps
    end

    Group.create :name =>  "ADV"
    Group.create :name =>  "ANALYTICS"
    Group.create :name =>  "CS"
    Group.create :name =>  "IT"
    Group.create :name =>  "KA"
    Group.create :name =>  "MERCH"
    Group.create :name =>  "MNGT"
    Group.create :name =>  "NA"
    Group.create :name =>  "OFFICE"
    Group.create :name =>  "OPERATIONS"
    Group.create :name =>  "OUT"
    Group.create :name =>  "PROD"
    Group.create :name =>  "TALENT"

  end


  def self.down
    drop_table :groups
    drop_table :groups_reports
  end
end

