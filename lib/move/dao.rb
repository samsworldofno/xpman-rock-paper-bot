require_relative '../../lib/dao'

class Move
  class Dao < Dao
    def create(attrs)
      db.lpush(match_key(attrs[:match_id]), attrs[:opponent_move])
    end

    def for_match(match_id:)
      db.lrange(match_key(match_id), 0, -1).split(" ").reverse
    end

    private

    def match_key(match_id)
      "matches:#{match_id}:moves"
    end
  end
end