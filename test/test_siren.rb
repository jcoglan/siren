$dir = File.dirname(__FILE__)

require $dir + '/../lib/siren'
require 'test/unit'

Dir[$dir + '/fixtures/**/*.rb'].each { |fixture| require fixture }

$VERBOSE = nil

class SirenTest < Test::Unit::TestCase
  
  def fixtures(name)
    @fixtures ||= {}
    @fixtures[name.to_sym] ||= Siren.parse(File.read("#{$dir}/fixtures/#{name}.json"))
  end
  
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
    
    assert_equal( 'something "funny"', Siren.parse('{"key": "something \\"funny\\""}')["key"] )
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
    assert_equal( {"people" => [mike, bob]}, fixtures(:people) )
  end
  
  def test_referencing
    person = fixtures(:refs).first
    assert person.equal?(person["favourite"])
    person = fixtures(:refs)[1]
    assert person.equal?(person.favourite)
    
    romeo, juliet = fixtures(:refs)[2..3]
    assert romeo.equal?(juliet.favourite)
    assert juliet.equal?(romeo.favourite)
  end
  
  def test_json_query
    assert_equal [5,6,7], Siren.query("$[? @ > 4 ]", 1..7)
    assert_equal "FOO", Siren.query("$.upcase", "foo")
    assert_equal 99, Siren.query("$['key']", {"key" => 99})
    assert_equal 4, Siren.query("$.values[$.key]", {"key" => 2, "values" => [3,9,4,6]})
    assert_equal 1, Siren.query("$[? @ = ('foo')]", %w(bar foo baz)).size
    assert_equal 2, Siren.query("$[?( @ != 'foo'  )]", %w(bar foo baz)).size
    
    assert_equal 2, Siren.query("$.data[? $.value != @]",
        {"value" => "foo", "data" => %w(bar foo baz)}).size
    
    Siren.parse '[{"id": "whizz", "name": "jcoglan"}]'
    assert_equal 'jcoglan', Siren.query("whizz.name", {})
  end
end

