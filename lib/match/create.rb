require_relative '../create_action'
require_relative '../match'

class Match
  class Create < CreateAction
    def subject
      Match
    end
  end
end