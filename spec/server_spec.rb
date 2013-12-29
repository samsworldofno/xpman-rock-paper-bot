require_relative '../lib/server'

require 'rack/test'

describe Server do
  include Rack::Test::Methods

  def app
    Server
  end

  describe 'POST /start' do
    let(:match_creator) { double }

    before do
      Server.set :actors, {
        match_creator: match_creator
      }
    end

    it 'creates a new match' do
      expect(match_creator).to receive(:call)
      .with({
        opponent_name: 'FATBOYSLIM',
        points_to_win: 2000,
        max_rounds: 1000,
        dynamite_count: 100
      })

      post '/start', {
        'opponentName'  => 'FATBOYSLIM',
        'pointsToWin'   => 2000,
        'maxRounds'     => 1000,
        'dynamiteCount' => 100
      }
    end
  end

  describe 'POST /move' do
    let(:move_creator)  { double }
    let(:match_get_current) do
      double(call: double('match', id: 11))
    end

    before do
      Server.set :actors, {
        move_creator: move_creator,
        match_get_current: match_get_current
      }
    end

    it 'creates a new move' do
      expect(move_creator).to receive(:call)
      .with({
        game_id: 11,
        opponent_move: 'PAPER'
      })

      post '/move', {
        'lastOpponentMove' => 'PAPER'
      }
    end
  end
end