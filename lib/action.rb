class Action
  attr_accessor :dao

  def initialize(dao: nil)
    self.dao = dao
  end

  def subject
    raise NotImplementedError
  end

  def build(attrs)
    attrs.inject(subject.new) do |builder, (attr, val)|
      builder.send("#{attr}=", val)
      builder
    end
  end
end