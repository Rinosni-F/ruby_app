# app/models/ticket.rb
class Ticket < ActiveRecord::Base
    self.table_name = 'dev_tables.tickets' # Use this if the table name is non-standard
  
    validates :name, presence: true
    validates :email, presence: true
    validates :booking_date, presence: true
    validates :bus_name, presence: true
    validates :quantity, presence: true
    validates :start_location, presence: true
    validates :end_location, presence: true
  end
  