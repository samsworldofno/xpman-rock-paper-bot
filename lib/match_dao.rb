class MatchDao < Struct.new(:db)
  def current_match_id
    db.get("game_id_counter")
  end

  def get(id)
    [:opponent_name, :points_to_win, :max_rounds, :dynamite_count].inject({}) do |match, attr|
      match[attr] = db.hget("game:#{id}", attr.to_s)

      match
    end
  end

  def create(attrs)
    id = new_match_id

    [:opponent_name, :points_to_win, :max_rounds, :dynamite_count].each do |attr|
      db.hset("game:#{id}", attr.to_s, attrs[attr])
    end

    id
  end

  private

  def new_match_id
    db.incr("game_id_counter")
  end
end
