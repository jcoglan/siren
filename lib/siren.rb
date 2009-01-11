require 'rubygems'
require 'treetop'

%w(walker parser node reference observer ../json ../json_query ../json_query/nodes).each do |path|
  require File.dirname(__FILE__) + '/siren/' + path
end

$p = JsonQueryParser.new

class JsonParser
  include Siren::Walker
end

module Siren
  VERSION = '0.1.0'
  
  TYPE_FIELD = "type"
  ID_FIELD   = "id"
  REF_FIELD  = "$ref"
  
  def self.parse(string, &block)
    @json_parser ||= JsonParser.new
    Reference.flush!
    @symbols = {}
    
    result = @json_parser.parse(string).value rescue nil
    
    @json_parser.walk(result) do |holder, key, value|
      if Hash === value && value[REF_FIELD]
        value = Reference.new(value) { |target| holder[key] = target }
      end
      value
    end
    
    @json_parser.walk(result) do |holder, key, value|
      if Hash === value
        id = value[ID_FIELD]
        value = Node.from_json(value)
        @symbols[id] = value
      end
      value
    end
    
    Reference.resolve!(@symbols)
    @json_parser.walk(result, &block) if block_given?
    
    result
  end
  
  def self.query(expression, root)
    @query_parser ||= JsonQueryParser.new
    @query_parser.parse(expression).value(root, @symbols ||{})
  end
end

