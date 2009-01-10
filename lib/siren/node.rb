module Siren
  module Node
    
    module ClassMethods
      def from_json(hash)
        object = self.new
        hash.each do |key, value|
          object.instance_variable_set("@#{key}", value)
        end
        object
      end
    end
    
    @classes = {}
    
    def self.included(base)
      base.class_eval { extend ClassMethods }
      @classes[base.name.split('::').last] = base
    end
    
    def self.from_json(hash)
      hash = Siren.parse(hash) if String === hash
      return hash unless Hash === hash && hash["type"]
      find_class(hash["type"]).from_json(hash)
    end
    
    def self.find_class(name)
      name = name.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
      @classes[name]
    end
    
  end
end

