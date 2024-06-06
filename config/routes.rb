require 'rack'

class Routes
  def initialize(client)
    @client = client
  end

  def call(env)
    request = Rack::Request.new(env)

    case request.path_info
    when '/'
      response = LoginController.new(@client).render_login_form
    when '/submit'
      response = request.post? ? LoginController.new(@client).handle_form_submission(request) : not_found
    when '/logout'
      response = LoginController.new(@client).render_login_form
    when '/add_user'
      response = AddUserController.new(@client).render_add_user_form
    when '/create_user'
      response = request.post? ? AddUserController.new(@client).handle_form_submission(request) : not_found
    when %r{/users/\d+}
      response = AddUserController.new(@client).show_user(request)
    when '/users'
      response = AddUserController.new(@client).render_user_list
    when '/home'
      response = LoginController.new(@client).render_home
    when %r{/edit_user/\d+}
    response = request.get? ? AddUserController.new(@client).edit_user(request) : not_found
    when %r{/update_user/\d+}
    response = request.post? ? AddUserController.new(@client).update_user(request) : not_found
    when %r{/delete_user/\d+}
    response = request.post? ? AddUserController.new(@client).delete_user(request) : not_found
    when '/tickets'
      response = TicketsController.new(@client).render_new
    when '/ticket_list'
      response = TicketsController.new(@client).ticket_list
    when %r{^/tickets/\d+$}
    response = TicketsController.new(@client).show_ticket(request)
    when '/tickets_book'
    response = request.post? ? TicketsController.new(@client).handle_form_submission(request) : not_found
    else
      response = not_found
    end

    response
  end

  private

  def not_found
    [404, { 'Content-Type' => 'text/html' }, ['Page Not Found']]
  end
end
