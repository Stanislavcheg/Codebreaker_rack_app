require 'codebreaker'
require_relative 'storage'
class Service
  def initialize
    @storage = Storage.new
  end

  def make_guess(game_id, guess)
    @game = @storage.get_game(game_id)
    return "Game over thank you for playing." if ended? @game
    begin
      result = @game.evaluate_guess guess
    rescue
      result = "Guess should consist of four numbers between 1 and 6."
    end

    @storage.set_game(game_id, @game)
    evaluate_result(result, @game)
  end

  def save_score(game_id, player_name)
    return unless player_name
    @game = @storage.get_game(game_id)
    score_string = @game.generate_score_string(player_name)
    path = File.expand_path("../../public/resources/scores.txt", __FILE__)
    open(path, 'a') { |file| file.puts score_string } if @game.is_guessed
    "Score saved!"
  end

  def render_home
    @game = Codebreaker::Game.new
    path = File.expand_path("../../public/pages/index.html", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end

  def start(game_id)
    @game.start
    @storage.set_game(game_id, @game)
    'Code was generated. Take a guess.'
  end

  def rules
    open_resource_file "rules.txt"
  end

  def scores
    scores = open_resource_file "scores.txt"
    formated_scores = scores.each_line.map { |line| "<li>#{line}</li>" }
    "<ul>#{formated_scores.join}</ul>"
  end

  def hint(game_id)
    @game = @storage.get_game(game_id)
    @game.show_hint
  end

  def generate_id(length = 10, range = 1..9)
    Array.new(length) { rand range }.join
  end

  private

  def open_resource_file(file)
    path = File.expand_path("../../public/resources/#{file}", __FILE__)
     File.exist?(path) ? File.open(path, "r") || File.new(path) : ""
  end

  def ended?(game)
    return true if game.current_turn > game.turns || game.is_guessed
    false
  end

  def evaluate_result(result, game)
    if game.is_guessed
      result = "win"
    elsif game.current_turn == game.turns
      result = "lost"
    end
    result
  end
end
