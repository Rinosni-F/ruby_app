# app/controllers/tickets_controller.rb
require 'erb'
require_relative '../models/ticket'

class TicketsController < ApplicationController
  def route_request(request)
    if request.get? && request.path == '/tickets'
      render_new
    elsif request.post? && request.path == '/tickets_book'
      handle_form_submission(request)
    elsif request.get? && request.path.match(/^\/tickets\/(\d+)$/)
      show_ticket($1.to_i)
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
    @success_message = nil
    @error_message = nil

    # Create a new Ticket instance with form parameters
    @ticket = Ticket.new(
      name: request.params['name'],
      email: request.params['email'],
      booking_date: request.params['booking_date'],
      bus_name: request.params['bus_name'],
      quantity: request.params['quantity'],
      start_location: request.params['start_location'],
      end_location: request.params['end_location']
    )

    # Save the ticket and set the success or error message
    if @ticket.save
      redirect_to("/tickets/#{@ticket.id}")
    else
      @error_message = 'Failed to add ticket.'
      render_new
    end
  end

  def show_ticket(id)
    @ticket = Ticket.find_by(id: id)
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

  def not_found
    [404, { 'Content-Type' => 'text/html' }, ['Page Not Found']]
  end

  def redirect_to(path)
    [302, { 'Location' => path }, []]
  end
end
