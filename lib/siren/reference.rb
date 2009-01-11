require 'observer'

module Siren
  class Reference
    
    include Observable
    
    def self.flush!
      @@cache = {}
    end
    
    def self.resolve!(root, symbols)
      @@cache.each { |id, ref| ref.resolve!(root, symbols) }
    end
    
    def initialize(hash, &block)
      @query = Siren.compile_query(hash[REF_FIELD])
      @@cache ||= {}
      @@cache[hash.__id__] = self
      add_observer(Observer.new(&block)) if block_given?
    end
    
    def resolve!(root, symbols)
      changed(true)
      notify_observers(self, root, symbols)
    end
    
    def find(root, symbols, current)
      @query.value(root, symbols, current)
    end
    
  end
end

