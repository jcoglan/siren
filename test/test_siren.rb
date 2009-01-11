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
    
    assert_equal "romeo", romeo.handle
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
    
    data = {"keys" => [1,7,9,5,6], :values => [4,0,5,2,8,1,7,9]}
    assert_equal 9, Siren.query("$.keys[? @ >= 9][0]", data)
    assert_equal [4,0,5,2,1], Siren.query("$.values[? $.keys[? @ = 6][0] > @ ]", data)
    
    assert_equal [1,3,4,5], Siren.query("$[? @ > 2 & @ < 6 | @ = 1]", 1..9)
    
    assert_equal 9, Siren.query("$.key[? @ = ($.val - 2) + 4][0]",
        {:key => [0,2,9,4,7], :val => 7})
    assert_equal "foobar", Siren.query("'foo' + 'bar'", {:val => 7})
    
    Siren.parse '[{"id": "whizz", "name": "jcoglan"}]'
    assert_equal 'jcoglan', Siren.query("whizz.name", {})
    
    assert_equal 5, Siren.query("$.store.*", fixtures(:store)).flatten.size
    assert_equal 2, Siren.query("$.store[*]", fixtures(:store)).size
    
    assert_equal [7,8], Siren.query("$.val[? @ > $.key.*.size * 2]",
        {:key => [9,5,7], :val => 1..8})
    
    assert_equal "The Lord of the Rings",
        Siren.query("$.store.book[@.length - 1]", fixtures(:store))["title"]
    
    assert_equal ["Sayings of the Century", "The Lord of the Rings"],
        Siren.query("$.store.book[0,3]", fixtures(:store)).map { |b| b["title"] }
    
    assert_equal fixtures(:store)["store"]["book"].map { |b| b["title"] },
        Siren.query("$.store.book[=title ]", fixtures(:store))
    
    assert_equal fixtures(:store)["store"]["book"].map { |b| b["title"] }.sort,
        Siren.query("$.store.book[/title][= @.title ]", fixtures(:store))
  end
end

