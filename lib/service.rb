require 'codebreaker'
class Service
  def make_guess(guess)
    if @game.current_turn < @game.turns
      begin
        result = @game.evaluate_guess guess
      rescue
        result = "Guess should consist of four numbers between 1 and 6."
      end
    else
      result = "lost"
    end
    if @game.is_guessed
      result = "win"
    end
    result
  end

  def save_score(player_name)
    return unless player_name
    score_string = @game.generate_score_string(player_name)
    path = File.expand_path("../../public/resources/scores.txt", __FILE__)
    open(path, 'a') { |file| file.puts score_string }
    "Score saved!"
  end

  def render_home
    @game = Codebreaker::Game.new
    path = File.expand_path("../../public/pages/index.html", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end

  def start
    @game.start
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

  def hint
    @game.show_hint
  end

  private

  def open_resource_file(file)
    path = File.expand_path("../../public/resources/#{file}", __FILE__)
    File.open(path, "r")
  end
end
