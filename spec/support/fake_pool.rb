class FakePool
  def initialize(double)
    @double = double
  end

  def with
    yield @double
  end
end
