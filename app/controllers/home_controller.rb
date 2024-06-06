class HomeController  < ApplicationController


  def render_user_list
    headers = { 'Content-Type' => 'text/html' }
    erb_file = File.read('app/views/home/index.html.erb')
    template = ERB.new(erb_file)
    response = template.result(binding)
    [200, headers, [response]]
  end

  # def redirect_to_index_with_message(message)
  #   @success_message = message
  #   @users = fetch_all_users_with_roles
  #   render_user_list
  # end
end
