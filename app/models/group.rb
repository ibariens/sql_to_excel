class Group < ActiveRecord::Base
  has_and_belongs_to_many :report
  has_many :users, :primary_key => :name , :foreign_key => :group
end


