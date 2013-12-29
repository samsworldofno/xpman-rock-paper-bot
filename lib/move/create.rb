require_relative '../create_action'
require_relative '../move'

class Move
  class Create < CreateAction
    def subject
      Move
    end
  end
end