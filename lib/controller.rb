require_relative 'service'
class Controller
  attr_reader :service

  def initialize
    @service = Service.new
  end

  def call(env)
    request = Rack::Request.new(env)
    case request.path
    when '/' then Rack::Response.new(service.render_home)
    when '/start' then Rack::Response.new(service.start)
    when '/hint' then Rack::Response.new(service.hint)
    when '/rules' then Rack::Response.new(service.rules)
    when '/scores' then Rack::Response.new(service.scores)
    when '/guess' then Rack::Response.new(service.make_guess(request.params['guess']))
    when '/save_score' then Rack::Response.new(service.save_score(request.params['name']))
    else Rack::Response.new('Not Found', 404)
    end
  end
end
