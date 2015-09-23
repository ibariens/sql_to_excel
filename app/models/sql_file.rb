class SqlFile < ActiveRecord::Base
  # The dir that contains all queries.
  # directory shouldn't end with '/'
  SQL_REPO_PATH = "#{Rails.root}/queries/BI/ART/Active/"
  has_one :report

  def self.add_files_to_db
    files = get_files_from_dirs
    files.each do |file|
      self.update_or_create_with_file_details(file)
    end
  end

  def self.get_files_from_dirs
    extension = "sql"
    local_files = Dir.glob(("#{SQL_REPO_PATH}/**/*.#{extension}")) # Double bracked is required!
    return local_files
  end

  def self.update_or_create_with_file_details(file)
    file_details = get_file_details(file)
    sql_file = SqlFile.where(:name => file_details[:name], :directory => file_details[:directory]).first
    if sql_file.nil?
      sql_file = SqlFile.create(file_details)
      sql_file.build_report(:name => file_details[:name],
                            :stored_sql => extract_sql(file),
                            :file_name => file_details[:name])
    elsif sql_file.last_modified < file_details[:last_modified]
      puts "#{file} is updated!"
      sql_file.last_modified = file_details[:last_modified]
      sql_file.report.stored_sql = extract_sql(file)
      sql_file.report.save!
    else
      sql_file.touch
    end
    sql_file.save!
  end

  def self.extract_sql(file)
    lines = File.open(file, "r:bom|utf-8").readlines
    sql = ''

    lines.each do |line|
      line.gsub! "\n", ""
      line.gsub! "\t", " "
      line = line.split(" --").first
      sql = "#{sql} #{line}"
    end

    return sql
  end


  def self.get_file_details(file_name_incl_path)
    opened_file = File.open(file_name_incl_path)
    file_hash = Hash.new

    file_hash[:name]               = File.basename(file_name_incl_path)
    file_hash[:directory]          = File.dirname(file_name_incl_path).gsub("#{SQL_REPO_PATH}",'')
    file_hash[:last_modified]      = opened_file.mtime

    return file_hash
  end
end