require_relative 'service'
class Controller
  attr_reader :service

  def initialize
    @service = Service.new
  end

  def call(env)
    request = Rack::Request.new(env)
    case request.path
    when '/'
      Rack::Response.new(service.render_home)
    when '/start'
      Rack::Response.new do |response|
        game_id = service.generate_id
        response.set_cookie('game_id', game_id)
        response.write(service.start(game_id))
      end
    when '/hint'
      Rack::Response.new(service.hint(request.cookies['game_id']))
    when '/rules'
      Rack::Response.new(service.rules)
    when '/scores'
      Rack::Response.new(service.scores)
    when '/guess'
      Rack::Response.new(service.make_guess(request.cookies['game_id'], request.params['guess']))
    when '/save_score'
      Rack::Response.new(service.save_score(request.cookies['game_id'], request.params['name']))
    else
      Rack::Response.new('Not Found', 404)
    end
  end
end
