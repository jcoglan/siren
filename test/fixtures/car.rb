class Car
  extend Siren::Node
  
  attr_reader :brand
  
  def initialize(brand = nil)
    @brand = brand
  end
  
  def ==(other)
    @brand == other.brand
  end
end

