require_relative '../../../lib/match/dao'

describe Match::Dao do
  let(:db) { double('redis', incr: 11, hmset: true, hget: true, get: 11) }

  subject(:dao) { described_class.new(db: db) }

  describe '#create' do
    it 'generates a new game id' do
      expect(db).to receive(:incr).with('match_id_counter').and_return(1)

      dao.create({})
    end

    it 'persists a hash' do
      expect(db).to receive(:hmset).with(
        'matches:11',
        'attr1', 'first attr',
        'attr2', 'second attr'
      )

      dao.create({attr1: 'first attr', attr2: 'second attr'})
    end

    it 'returns the game id' do
      expect(dao.create({})).to eq(11)
    end
  end

  describe '#current_match_id' do
    before do
      db.stub(get: 11)
    end

    it 'fetches the current id from the db' do
      expect(db).to receive(:get).with('match_id_counter')

      dao.current_match_id
    end

    it 'returns the current id' do
      expect(dao.current_match_id).to eq(11)
    end
  end
end