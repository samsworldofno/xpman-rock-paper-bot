require 'spec_helper'

require_relative '../../../lib/move/dao'

describe Move::Dao do
  let(:db)      { double }

  subject(:dao) { described_class.new(db: db) }

  describe '#create' do
    it 'saves the move against the passed game id' do
      expect(db).to receive(:lpush).with("matches:11:moves", 'PAPER')

      dao.create({
        game_id: 11,
        opponent_move: 'PAPER'
      })
    end
  end
end