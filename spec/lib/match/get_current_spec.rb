require 'spec_helper'

require_relative '../../../lib/match/get_current'

describe Match::GetCurrent do
  let(:dao) { double('dao', current_match_id: 11) }

  subject(:get_current) { described_class.new(dao: dao) }

  describe '#call' do
    it 'gets the current match id from the dao' do
      expect(dao).to receive(:current_match_id)

      get_current.call
    end

    describe 'returned Match' do
      subject(:match) do
        get_current.call
      end

      specify do
        expect(match).to be_a Match
      end

      its(:id) { should == 11 }
    end
  end
end