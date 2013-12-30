require_relative '../action'

class Move
  class Historian < Action
    def call(match_id:)
      dao.for_match(match_id: match_id)
    end
  end
end
