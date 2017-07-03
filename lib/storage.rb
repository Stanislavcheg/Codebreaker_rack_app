require 'yaml/store'

class Storage
  def initialize
    path = File.expand_path("../../public/resources/db.yaml", __FILE__)
    @db = YAML::Store.new path
  end

  def get_game(game_id)
    @db.transaction { @db[game_id] }
  end

  def set_game(game_id, game)
    @db.transaction { @db[game_id] = game }
  end
end
