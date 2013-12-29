require_relative '../../lib/dao'

class Move
  class Dao < Dao
    def create(attrs)
      db.lpush("matches:#{attrs[:game_id]}:moves", attrs[:opponent_move])
    end
  end
end