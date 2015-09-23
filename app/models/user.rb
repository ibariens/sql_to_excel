class User < ActiveRecord::Base
  attr_accessor :password
  before_save :encrypt_password

  has_many :owners
  has_many :reports, through: :owners
  has_many :file_names

  belongs_to :group,  :primary_key => :name , :foreign_key => :group

  def self.authenticate(username, password)
    user = User.find_by_username(username)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def is_admin?
      return self.hierarchy == 2
  end
end
