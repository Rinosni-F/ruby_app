# app/models/ticket.rb

class Ticket
    attr_accessor :name, :email, :booking_date, :bus_name, :quantity
  
    def initialize(attributes = {})
      @name = attributes[:name]
      @email = attributes[:email]
      @booking_date = attributes[:booking_date]
      @bus_name = attributes[:bus_name]
      @quantity = attributes[:quantity]
    end
    def save_to_db(database)
        query = "INSERT INTO tickets (name, email, booking_date, bus_name, quantity) VALUES (?, ?, ?, ?, ?)"
        statement = database.prepare(query)
        statement.execute(name, email, booking_date, bus_name,quantity)
      end
  end
  