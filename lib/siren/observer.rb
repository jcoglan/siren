module Siren
  class Observer
    
    def initialize(&block)
      @block = block
    end
    
    def update(*args)
      @block.call(*args)
    end
    
  end
end

