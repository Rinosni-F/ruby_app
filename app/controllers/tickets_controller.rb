require 'bcrypt'

class TicketsController < ApplicationController
  
  def route_request(request)
    if request.get? && request.path == '/tickets'
      render_new
    elsif request.post? && request.path == '/tickets_book'
      handle_form_submission(request)
      render_ticket_list
    else
      render_ticket_list
    end
  end

  private

  def render_new
    headers = {'Content-Type' => 'text/html'}
    erb_file = File.read('app/views/tickets/new.html.erb')
    template = ERB.new(erb_file)
    response = template.result(binding)
    [200, headers, [response]]
  end

  def handle_form_submission(request)
    @name = request.params['name']
    @email = request.params['email']
    @booking_date = request.params['booking_date']
    @bus_name = request.params['bus_name']
    @quantity = request.params['quantity']

    if insert_user
      redirect_to_index_with_message('ticket added successfully!')
      # @tickets = fetch_all_tickets
    end
  end

  def insert_user
    query = "INSERT INTO tickets (name, email, booking_date, bus_name, quantity) VALUES (?, ?, ?, ?, ?)"
    statement = @client.prepare(query)
    statement.execute(@name, @email, @booking_date, @bus_name, @quantity)
    true # Return true to indicate success
  rescue StandardError => e
    puts "Error inserting ticket: #{e.message}" # Log the error message
    false # Return false to indicate failure
  end

  def redirect_to_index_with_message(message)
    @success_message = message
    @tickets = fetch_all_tickets
    render_ticket_list
  end

  def fetch_all_tickets
    query = "SELECT id, name, email, booking_date, bus_name, quantity FROM tickets"
    statement = @client.prepare(query)
    result = statement.execute.to_a
    puts "Fetched Users: #{result.inspect}" # Debugging line
    result
  end

  def render_ticket_list
    headers = { 'Content-Type' => 'text/html' }
    erb_file = File.read('app/views/tickets/index.html.erb')
    template = ERB.new(erb_file)
    response = template.result(binding)
    [200, headers, [response]]
  end
end
