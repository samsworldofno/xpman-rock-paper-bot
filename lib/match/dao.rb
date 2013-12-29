require_relative '../dao'

class Match
  class Dao < Dao
    def create(attrs)
      id = new_match_id

      setters = attrs.flatten.collect(&:to_s)

      db.hmset("matches:#{id}", *setters)

      id
    end

    def current_match_id
      db.get("match_id_counter")
    end

    private

    def new_match_id
      db.incr("match_id_counter")
    end
  end
end