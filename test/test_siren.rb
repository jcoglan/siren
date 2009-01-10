$dir = File.dirname(__FILE__)

require $dir + '/../lib/siren'
require 'test/unit'

Dir[$dir + '/fixtures/**/*.rb'].each { |fixture| require fixture }

class SirenTest < Test::Unit::TestCase
  
  def test_parser
    
    assert_equal(
        {"foo" => 12},
        Siren.parse('{"foo": 12}') )
    
    assert_equal(
        {"foo" => {"something" => true}},
        Siren.parse('{"foo": {"something": true}}') )
    
    assert_equal(
        {"list" => [1,2,"value"]},
        Siren.parse('{"list": [1, 2, "value"]}') )
    
    assert_equal(
        {"list" => []},
        Siren.parse('  {  "list"  : [    ]  }  ') )
    
    assert_equal( {}, Siren.parse("{}") )
    assert_equal( [], Siren.parse("[]") )
    assert_equal( nil, Siren.parse("undefined") )
  end
  
  def test_parser_with_callback
    value = Siren.parse('{"list": [1,2,3,[56,34],4,5,6]}') do |holder, key, v|
      Numeric === v ? key + v : v
    end
    
    assert_equal( {"list" => [1,3,5,[56,35],8,10,12]}, value )
  end
  
  def test_casting
    mike = Person.new('ford')
    bob = Person.new('bentley', 'ferrari', 'zonda')
    
    data = Siren.parse(File.read($dir + '/fixtures/people.json'))
    
    assert_equal( {"people" => [mike, bob]}, data )
  end
  
end

