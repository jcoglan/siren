module Siren
  module Node
    
    def from_json(hash)
      object = self.new
      hash.each do |key, value|
        object.instance_variable_set("@#{key}", value)
        if Reference === value
          value.on(:resolve) do |ref, root, symbols|
            object.instance_variable_set("@#{key}", ref.find(root, symbols, object))
          end
        end
      end
      object
    end
    
    @classes = {}
    
    def self.extended(base)
      @classes[base.name.split('::').last] = base
    end
    
    def self.from_json(hash)
      hash = Siren.parse(hash) if String === hash
      return hash unless Hash === hash && hash[TYPE_FIELD]
      klass = find_class(hash[TYPE_FIELD])
      klass ? klass.from_json(hash) : hash
    end
    
    def self.find_class(name)
      name = name.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
      @classes[name]
    end
    
  end
end

