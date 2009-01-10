%w(parser node).each do |path|
  require File.dirname(__FILE__) + '/siren/' + path
end

module Siren
  VERSION = '0.1.0'
  
  def self.parse(string, &block)
    @parser ||= Parser.new
    result = @parser.parse(string, &block)
    
    @parser.walk(result) do |holder, key, value|
      Hash === value ? Node.from_json(value) : value
    end
    
    result
  end
end

