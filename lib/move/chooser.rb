class Move
  class Chooser
    def call(previous_moves:)
      Decision.new(previous_moves: previous_moves).call
    end

    class Decision
      WINNERS = {
        'DYNAMITE' => 'WATERBOMB',
        'PAPER' => 'SCISSORS',
        'SCISSORS' => 'ROCK',
        'ROCK' => 'PAPER'
      }

      attr_accessor :previous_moves

      def initialize(previous_moves:)
        self.previous_moves = previous_moves
      end

      def call
        if first_move?
          'DYNAMITE'
        elsif last_move_was_dynamite?
          'DYNAMITE'
        elsif very_popular_move? && coin_flip == :heads
          WINNERS[very_popular_move]
        elsif dice_roll == 1 || dice_roll == 2
          'DYNAMITE'
        elsif dice_roll == 3
          opponents_last_move
        else
          %w{DYNAMITE SCISSORS PAPER ROCK}.sample
        end
      end

      private

      def coin_flip
        @coin_flip ||= rand(1) ? :heads : :tails
      end

      def dice_roll
        @dice_roll ||= rand(4) + 1
      end

      def first_move?
        previous_moves.length == 0
      end

      def last_move_was_dynamite?
        previous_moves.last == 'DYNAMITE'
      end

      def very_popular_move?
        !!very_popular_move
      end

      def very_popular_move
        grouped_moves = previous_moves.group_by(&:to_s)

        move_percentages = grouped_moves.inject({}) do |memo, (key, val)|
          memo[key] = val.count.to_f / previous_moves.length
          memo
        end

        move_popular_move = move_percentages.select do |move, percent|
          percent > 0.6
        end.keys.first
      end

      def opponents_last_move
        previous_moves.last
      end
    end
  end
end