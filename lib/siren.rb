require 'rubygems'
require 'treetop'
require 'eventful'

%w[ json json_query json_query_nodes
    walker parser node reference
].each do |path|
  require File.dirname(__FILE__) + '/siren/' + path
end

module Siren
  VERSION = '0.1.0'
  
  TYPE_FIELD = "type"
  ID_FIELD   = "id"
  REF_FIELD  = "$ref"
  
  class JsonParser
    include Siren::Walker
  end
  
  def self.parse(string, &block)
    @json_parser ||= JsonParser.new
    Reference.flush!
    @symbols = {}
    
    result = @json_parser.parse(string).value rescue nil
    
    @json_parser.walk(result) do |holder, key, value|
      if Hash === value && value[REF_FIELD]
        value = Reference.new(value)
        value.on(:resolve) do |ref, root, symbols|
          holder[key] = ref.find(root, symbols, holder)
        end
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
    
    Reference.resolve!(result, @symbols)
    @json_parser.walk(result, &block) if block_given?
    
    result
  end
  
  def self.query(expression, root)
    compile_query(expression).value(root, @symbols || {})
  end
  
  def self.compile_query(expression)
    @query_parser ||= JsonQueryParser.new
    @query_cache  ||= {}
    @query_cache[expression] ||= @query_parser.parse(expression)
  end
end

