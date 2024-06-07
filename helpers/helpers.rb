# helpers/helpers.rb
require 'erb'

def render_partial(file_path, locals = {})
  erb_file = File.read(file_path)
  template = ERB.new(erb_file)
  template.result_with_hash(locals)
end
