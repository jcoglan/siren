module Siren
  class Reference
    
    include Eventful
    
    def self.flush!
      @@cache = {}
    end
    
    def self.resolve!(root, symbols)
      @@cache.each { |id, ref| ref.resolve!(root, symbols) }
    end
    
    def initialize(hash)
      @query = Siren.compile_query(hash[REF_FIELD])
      @@cache ||= {}
      @@cache[hash.__id__] = self
    end
    
    def resolve!(root, symbols)
      fire(:resolve, root, symbols)
    end
    
    def find(root, symbols, current)
      @query.value(root, symbols, current)
    end
    
  end
end

