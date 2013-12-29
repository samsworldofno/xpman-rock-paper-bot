require_relative '../action'
require_relative '../match'

class Match
  class GetCurrent < Action
    def subject
      Match
    end

    def call
      attrs = {}
      attrs[:id] = dao.current_match_id

      build(attrs)
    end
  end
end