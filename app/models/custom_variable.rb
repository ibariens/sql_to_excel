class CustomVariable < ActiveRecord::Base
  #def self.fetch(custom_variable, user_id = nil)
  #
  #  if custom_variable == "current_user" && !user_id.nil?
  #    return user_id
  #  end
  #  custom_variable = custom_variable.delete "{}"
  #
  #  cv = CustomVariable.find_by_name(custom_variable) || raise("Somehow custom_variable's not set #{custom_variable}")
  #  results = External.connection.execute(cv.stored_sql)
  #  results
  #end


  def result
    results = External.connection.execute(self.stored_sql)
    array_result = results.map do |row|
                    [row['name'], row['value']]
    end
    array_result
  end
end