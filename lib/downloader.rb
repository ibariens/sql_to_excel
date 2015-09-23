class Downloader < External
  @queue = :report_execute

  def self.perform(report_id, user_id, custom_sql = nil)
    report = Report.find(report_id) || raise("report not found, maybe switched report_id with user_id?")
    user = User.find(user_id) || raise("report not found, maybe switched report_id with user_id?")

    if report.nil?
      raise("invalid report id given")
    end

    begin_time = Time.now
      records_array = self.connection.execute(custom_sql || report.stored_sql)
    end_time = Time.now
    computation_time = end_time - begin_time

    report.execution_time = computation_time
    report.last_execution = Time.now
    ToXlsx.generate_xlsx(records_array, report.id, user.id)

    report.save
  end
end