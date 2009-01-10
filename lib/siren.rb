%w(parser node reference observer).each do |path|
  require File.dirname(__FILE__) + '/siren/' + path
end

module Siren
  VERSION = '0.1.0'
  
  TYPE_FIELD = "type"
  ID_FIELD   = "id"
  REF_FIELD  = "$ref"
  
  def self.parse(string, &block)
    @parser ||= Parser.new
    Reference.flush!
    identified = {}
    
    result = @parser.parse(string) do |holder, key, value|
      if Hash === value && value[REF_FIELD]
        value = Reference.new(value) { |target| holder[key] = target }
      end
      value
    end
    
    @parser.walk(result) do |holder, key, value|
      if Hash === value
        id = value[ID_FIELD]
        value = Node.from_json(value)
        identified[id] = value
      end
      value
    end
    
    Reference.resolve!(identified)
    @parser.walk(result, &block) if block_given?
    
    result
  end
end

