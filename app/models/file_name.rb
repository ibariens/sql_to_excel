class FileName < ActiveRecord::Base
  belongs_to :user
  belongs_to :report

  def self.generate_output_file_name(report_id, current_user_id)
    report = Report.find(report_id) || raise("Report id not found")
    file_name = "#{report.file_name}_#{current_user_id}_#{Time.now.strftime "%d%m%Y%H%M%S"}"
    file_name
  end

  def path_to_file
    # Check if reports directory exists
    Dir.mkdir("#{Rails.root}/reports") unless File.exists?("#{Rails.root}/reports")
    "#{Rails.root}/reports/#{self.last_file_name}.xlsx"
  end
end

