require 'spec_helper'

require_relative '../../../lib/move/historian'

describe Move::Historian do
  describe '#call' do
    let(:dao) { double }

    subject(:historian) { described_class.new(dao: dao) }

    it 'requests the previous moves from the dao for this match' do
      expect(dao).to receive(:for_match).with(match_id: 11)

      historian.call(match_id: 11)
    end

    it 'is the previous moves in the game' do
      dao.stub(for_match: %w{ROCK PAPER SCISSORS} )

      expect(historian.call(match_id: 11)).to eq(['ROCK', 'PAPER', 'SCISSORS'])
    end
  end
end