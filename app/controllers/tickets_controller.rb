class TicketsController < ApplicationController
  def route_request(request)
    if request.get? && request.path == '/tickets'
      render_new
    elsif request.post? && request.path == '/tickets_book'
      handle_form_submission(request)
    else
      render_new
    end
  end

  private

  def render_new
    headers = { 'Content-Type' => 'text/html' }
    erb_file = File.read('app/views/tickets/new.html.erb')
    template = ERB.new(erb_file)
    response = template.result(binding)
    [200, headers, [response]]
  end

  def handle_form_submission(request)
    @name = request.params['name']
    @success_message = nil
    @error_message = nil

    @name = request.params['name']
    @email = request.params['email']
    @booking_date = request.params['booking_date']
    @bus_name = request.params['bus_name']
    @quantity = request.params['quantity']

    if insert_ticket
      @success_message = 'Ticket added successfully!'
    else
      @error_message = 'Failed to add ticket.'
    end

    render_new
  end

  def insert_ticket
    query = "INSERT INTO tickets (name, email, booking_date, bus_name, quantity) VALUES (?, ?, ?, ?, ?)"
    statement = @client.prepare(query)
    statement.execute(@name, @email, @booking_date, @bus_name, @quantity)
    true # Return true to indicate success
  rescue StandardError => e
    puts "Error inserting ticket: #{e.message}" # Log the error message
    false # Return false to indicate failure
  end
end
