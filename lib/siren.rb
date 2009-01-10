%w(parser node).each do |path|
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
      identified[value[ID_FIELD]] = value if Hash === value
      block ? block.call(holder, key, value) : value
    end
    
    @parser.walk(result) do |holder, key, value|
      if Hash === value
        value = identified[value[REF_FIELD]] if value[REF_FIELD]
        value = Node.from_json(value)
      end
      value
    end
    
    result
  end
end

