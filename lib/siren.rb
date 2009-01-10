%w(parser node reference).each do |path|
  require File.dirname(__FILE__) + '/siren/' + path
end

module Siren
  VERSION = '0.1.0'
  
  TYPE_FIELD = "type"
  ID_FIELD   = "id"
  REF_FIELD  = "$ref"
  
  def self.parse(string, &block)
    @parser ||= Parser.new
    identified = {}
    
    result = @parser.parse(string) do |holder, key, value|
      if Hash === value
        identified[value[ID_FIELD]] = value
        value = Reference.new(value) if value[REF_FIELD]
      end
      block ? block.call(holder, key, value) : value
    end
    
    @parser.walk(result) do |holder, key, value|
      value = value.resolve(identified) if Reference === value
      value = Node.from_json(value) if Hash === value
      value
    end
    
    result
  end
end

