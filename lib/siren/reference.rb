module Siren
  class Reference
    
    def initialize(hash)
      @id = hash[REF_FIELD]
      puts @id
    end
    
    def resolve(table)
      table[@id]
    end
    
  end
end

