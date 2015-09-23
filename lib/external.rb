class External < ActiveRecord::Base
  self.abstract_class = true
  establish_connection ENV['BIG_DATA_URL'] || raise("External Database Not Set")

  # Remove this sub to allow writing to the database
  def readonly?
    true
  end
end