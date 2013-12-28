require 'singleton'

class MatchManager
  include Singleton

  def create(opts)
    match = build(opts)

    dao.create(
      opponent_name: match.opponent_name,
      points_to_win: match.points_to_win,
      max_rounds: match.max_rounds,
      dynamite_count: match.dynamite_count
    )

    match
  end

  def current
    id = dao.current_match_id

    load(id)
  end

  private

  def dao
    @dao || MatchDao.new(RedisConnection.instance.db)
  end

  def load(id)
    attrs = dao.get(id)
    build(attrs)
  end

  def build(attrs)
    match = Match.new

    attrs.each do |attr, val|
      match.send("#{attr}=", val) if match.respond_to?("#{attr}=")
    end

    match
  end
end