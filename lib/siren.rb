%w(parser).each do |path|
  require File.dirname(__FILE__) + '/siren/' + path
end

module Siren
  VERSION = '0.1.0'
  
  def self.parse(string, &block)
    @parser ||= Parser.new
    @parser.parse(string, &block)
  end
end

