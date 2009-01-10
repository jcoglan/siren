require 'observer'

module Siren
  class Reference
    
    include Observable
    
    def self.flush!
      @@cache = {}
    end
    
    def self.resolve!(table)
      @@cache.each { |id, ref| ref.resolve!(table) }
    end
    
    def initialize(hash, &block)
      @id = hash[REF_FIELD]
      @@cache ||= {}
      @@cache[@id] = self
      add_observer(Observer.new(&block)) if block_given?
    end
    
    def resolve!(table)
      changed(true)
      notify_observers(table[@id])
    end
    
  end
end

