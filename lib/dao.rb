class Dao
  attr_accessor :db

  def initialize(db:)
    self.db = db
  end
end