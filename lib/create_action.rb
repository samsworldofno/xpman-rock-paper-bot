require_relative './action'

class CreateAction < Action
  def call(attrs)
    dao.create(attrs) if dao

    build(attrs)
  end
end