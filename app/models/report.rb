class Report < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :file_name
  validates_presence_of :stored_sql

  has_many :owners
  has_many :users, through: :owners
  has_and_belongs_to_many :groups
  has_many :file_names


 def self.for_user(user_id)
    if User.find(user_id).is_admin?
     self.all.order("reports.name")
             .joins("INNER JOIN sql_files ON reports.sql_file_id = sql_files.id")
             .where("sql_files.updated_at > NOW()::DATE")
    else
     self.joins("LEFT JOIN groups_reports ON groups_reports.report_id = reports.id")
         .joins("LEFT JOIN groups ON groups_reports.group_id = groups.id")
         .joins("LEFT JOIN owners ON owners.report_id = reports.id")
         .joins("LEFT JOIN users ON users.id = owners.user_id")
         .joins("INNER JOIN sql_files ON reports.sql_file_id = sql_files.id")
         .where("groups.id = ? OR users.id = ?", User.find(user_id).group.id, user_id)
         .where("sql_files.updated_at > NOW()::DATE")
         .order("groups.name ASC")
         .order("reports.name")
    end
  end

  def self.without_group_with_owner(user_id)
    reports = Report.for_user(user_id)
    reports.joins("LEFT JOIN groups_reports ON groups_reports.report_id = reports.id")
           .joins("LEFT JOIN owners ON owners.report_id = reports.id")
           .where("group_id is null")
           .where("user_id is not null")
  end

  def self.without_group_without_owner(user_id)
    reports = Report.for_user(user_id)
    reports.joins("LEFT JOIN groups_reports ON groups_reports.report_id = reports.id")
           .joins("LEFT JOIN owners ON owners.report_id = reports.id")
           .where("group_id is null")
           .where("user_id is null")
  end


  def stored_sql=(stored_sql)
    # Store the sql in a clean way.
    stored_sql = stored_sql.squish
    super stored_sql
  end




  def has_custom_variables
    !self.stored_sql.to_s.match(/{{([A-Za-z0-9_]+)}}/).nil?
  end

  def fetch_custom_variables
     cvs = self.stored_sql.to_s.gsub(/{{([A-Za-z0-9_]+)}}/).map do |custom_variable|
            custom_variable.delete "{}"
     end
    cvs
  end

  def fill_custom_variables(params)
    sql = self.stored_sql.to_s
    adjusted_sql = sql.to_s.gsub(/{{([A-Za-z0-9_]+)}}/) do |custom_variable|
       param_array = params[custom_variable.delete("{}").to_sym]
       quoted = param_array.map{ |i|  %Q('#{i}') }.join(',')
       "(#{quoted})"
    end
    adjusted_sql
  end

  def current_user_only?
    (self.fetch_custom_variables.include? "current_user") && (self.fetch_custom_variables.count == 1)
  end





  def self.possible_owners
    User.all.where.not(:group => 'OUT').order(:username).map do |user|
      [user.display_name, user.id]
    end
  end

  def selected_owners
    self.users.collect {|x| x.id}
  end


  def self.possible_groups
    Group.all.order(:name).map do |group|
      [group.name, group.id]
    end
  end


  def selected_groups
    self.groups.collect {|x| x.id}
  end



  def get_additional_owners
    report_groups = self.groups.all.map(&:name)
    extra_owners = Array.new
    self.users.each do |user|
      if user.group && (!report_groups.include? user.group.name)
        extra_owners << user.display_name
      end
    end
    return extra_owners
  end

  def last_file_for_user(user_id)
    file = self.file_names.where("user_id = ?", user_id).first
    if file.nil?
      file = self.file_names.new(:user_id => user_id, :report_id => self.id)
    end
    file
  end


  def self.test_reports
    user_id = User.where(:username => 'bart.ariens').first.id
    Report.all.each do |report|
     unless report.has_custom_variables
       Resque.enqueue(Downloader,report.id, user_id)
     end
    end
  end




  # A quick hack since I couldn't get: accept_nested_attributes_for to work
  # If someone knows how to do this better, please let me know.
  def users=(user_ids)
    self.users.delete_all # Not very pretty
    user_ids.each do |user_id|
      self.users << User.find(user_id) unless user_id.blank?
    end
  end

  def groups=(group_ids)
    self.groups.delete_all # Not very pretty
    group_ids.each do |group_id|
      self.groups << Group.find(group_id) unless group_id.blank?
    end
  end

end

class ReportGroup < ActiveRecord::Base
  belongs_to :group
  belongs_to :report
end
