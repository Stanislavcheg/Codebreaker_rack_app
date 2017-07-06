require 'rack/test'
require 'rspec'
require './lib/controller'

describe 'Controller' do
  include Rack::Test::Methods

  OUTER_APP = Rack::Builder.parse_file("./config.ru").first

  def app
    OUTER_APP
  end

  context 'when goes to root' do
    it 'responds with 200 status' do
      get '/'
      expect(last_response.status).to eq 200
    end

    it "contains appropriate text" do
      get '/'
      expect(last_response.body).to include('Codebreaker')
    end
  end

  context 'when goes to nonexistent_path' do
    it 'responds with 404 status' do
      get '/asdf'
      expect(last_response.status).to eq 404
    end
  end

  context 'when goes to /start' do
    it 'responds with 200 status' do
      get '/start'
      expect(last_response.status).to eq 200
    end

    it "returns appropriate message" do
      get '/start'
      expect(last_response.body).to include('Code was generated. Take a guess.')
    end
  end

  context 'when goes to /guess' do
    before do
      get '/start'
    end
    it 'responds with 200 status' do
      post '/guess', :guess => '1234'
      expect(last_response.status).to eq 200
    end
  end

  context 'when goes to /hint' do
    before do
      get '/start'
    end
    it 'responds with 200 status' do
      get '/hint'
      expect(last_response.status).to eq 200
    end
  end

  context 'when goes to /rules' do
    it 'responds with 200 status' do
      get '/rules'
      expect(last_response.status).to eq 200
    end

    it "contains appropriate text" do
      get '/rules'
      expect(last_response.body).to include("It's a logic game in which a code-breaker tries to break a secret code of four numbers between 1 and 6.")
    end
  end

  context 'when goes to /scores' do
    it 'responds with 200 status' do
      get '/scores'
      expect(last_response.status).to eq 200
    end
  end
end

