class ToXlsx
  def self.generate_xlsx(results, report_id, current_user_id)
    expect! results => PG::Result, name => [String, nil]
    report = Report.find(report_id) || raise("report not found, maybe switched report_id with user_id?")
    user = User.find(current_user_id) || raise("report not found, maybe switched report_id with user_id?")

    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(:name => "Results") do |sheet|
        sheet.add_row results.fields

        results.each_row do |row|
          sheet.add_row(row)
        end
      end

      file = report.last_file_for_user(user.id)
      file.last_file_name = FileName.generate_output_file_name(report.id, user.id)
      file.save

      p.serialize(File.open(file.path_to_file, 'w'))
    end
  end
end
