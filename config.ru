require './lib/controller'

use Rack::Static, urls: ['/styles', '/scripts'], root: 'public'
run Controller.new
