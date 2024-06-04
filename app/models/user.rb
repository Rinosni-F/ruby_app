# app/models/user.rb
class User < ActiveRecord::Base
    self.table_name = 'dev_tables.users' # Use this if the table name is non-standard
    has_secure_password

    validates :username, presence: true
    validates :email, presence: true
    validates :password_digest, presence: true
    validates :role, presence: true
  end
  