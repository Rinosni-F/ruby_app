require_relative '../models/ticket'

class TicketsController < ApplicationController

  def render_new
    headers = { 'Content-Type' => 'text/html' }
    erb_file = File.read('app/views/tickets/new.html.erb')
    template = ERB.new(erb_file)
    response = template.result(binding)
    [200, headers, [response]]
  end

  def handle_form_submission(request)
    @success_message = nil
    @error_message = nil

    @ticket = Ticket.new(
      name: request.params['name'],
      email: request.params['email'],
      booking_date: request.params['booking_date'],
      bus_name: request.params['bus_name'],
      quantity: request.params['quantity'],
      start_location: request.params['start_location'],
      end_location: request.params['end_location']
    )

    if @ticket.save
      redirect_to("/tickets/#{@ticket.id}")
    else
      @error_message = 'Failed to add ticket.'
      render_new
    end
  end

  def show_ticket(request)
    ticket_id = request.path.split('/').last.to_i
    @ticket = Ticket.find_by(id: ticket_id)
    if @ticket
      render_show
    else
      not_found
    end
  end

  def render_show
    headers = { 'Content-Type' => 'text/html' }
    erb_file = File.read('app/views/tickets/show.html.erb')
    template = ERB.new(erb_file)
    response = template.result(binding)
    [200, headers, [response]]
  end
  def ticket_list
    @tickets = Ticket.all

    headers = { 'Content-Type' => 'text/html' }
    erb_file = File.read('app/views/tickets/index.html.erb')
    template = ERB.new(erb_file)
    response = template.result(binding)
    [200, headers, [response]]
  end

  def not_found
    [404, { 'Content-Type' => 'text/html' }, ['Page Not Found']]
  end

  def redirect_to(path)
    [302, { 'Location' => path }, []]
  end
end
