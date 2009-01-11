module JsonQuery
  
  @current = nil
  def self.current; @current; end
  
  def self.currently(object)
    present = @current
    @current = object
    result = yield
    @current = present
    result
  end
  
  class Query < Treetop::Runtime::SyntaxNode
    def value(root, symbols)
      object = identifier.value(root, symbols)
      filters.inject(object) { |value, filter| filter.value(value, root, symbols) }
    end
    
    def filters
      elements[1].elements
    end
  end
  
  module Identifier
  end
  
  class Root < Treetop::Runtime::SyntaxNode
    def value(root, symbols)
      root
    end
  end
  
  class Current < Treetop::Runtime::SyntaxNode
    def value(root, symbols)
      JsonQuery.current
    end
  end
  
  class Symbol < Treetop::Runtime::SyntaxNode
    def value(root, symbols)
      symbols[text_value]
    end
  end
  
  module Filter
  end
  
  module FieldAccess
    def index(object, root, symbols)
      element = elements[1]
      return element.text_value if Symbol === element
      JsonQuery.currently(object) { element.value(root, symbols) }
    end
    
    def value(object, root, symbols)
      index = index(object, root, symbols)
      
      return (Hash === object ? object.values : object) if index == :*
      return object[index] if Array === object and Numeric === index
      
      if Hash === object
        key = [index, index.to_s, index.to_sym].find { |i| object.has_key?(i) }
        return object[key] if key
      end
      
      return object.__send__(index) if object.respond_to?(index)
      object.instance_variable_get("@#{ index }")
    end
  end
  
  class AllFilter < Treetop::Runtime::SyntaxNode
    def value(root, symbols)
      :*
    end
  end
  
  class BooleanFilter < Treetop::Runtime::SyntaxNode
    def value(list, root, symbols)
      list.select do |object|
        JsonQuery.currently(object) { boolean_expression.value(root, symbols) }
      end
    end
  end
  
  class And < Treetop::Runtime::SyntaxNode
    def value(root, symbols)
      first.value(root, symbols) && second.value(root, symbols)
    end
  end
  
  class Or < Treetop::Runtime::SyntaxNode
    def value(root, symbols)
      first.value(root, symbols) || second.value(root, symbols)
    end
  end
  
  class BooleanAtom < Treetop::Runtime::SyntaxNode
    def value(root, symbols)
      element = elements[1]
      return element.boolean_expression.value(root, symbols) if element.respond_to?(:boolean_expression)
      comparator.value(first.value(root, symbols), second.value(root, symbols))
    end
    
    def comparator
      elements[1].comparator
    end
    
    def first
      elements[1].first
    end
    
    def second
      elements[1].second
    end
  end
  
  class Multiplicative < Treetop::Runtime::SyntaxNode
    def value(root, symbols)
      operator.value(first.value(root, symbols), second.value(root, symbols))
    end
  end
  
  class Additive < Treetop::Runtime::SyntaxNode
    def value(root, symbols)
      operator.value(first.value(root, symbols), second.value(root, symbols))
    end
  end
  
  class Atom < Treetop::Runtime::SyntaxNode
    def value(root, symbols)
      element = elements[1]
      return element.expression.value(root, symbols) if element.respond_to?(:expression)
      element.value(root, symbols)
    end
  end
  
  class Multiplication < Treetop::Runtime::SyntaxNode
    def value(expr1, expr2)
      expr1 * expr2
    end
  end
  
  class Division < Treetop::Runtime::SyntaxNode
    def value(expr1, expr2)
      expr1 / expr2
    end
  end
  
  class Addition < Treetop::Runtime::SyntaxNode
    def value(expr1, expr2)
      String === expr1 || String === expr2 ?
          expr1.to_s + expr2.to_s :
          expr1 + expr2
    end
  end
  
  class Subtraction < Treetop::Runtime::SyntaxNode
    def value(expr1, expr2)
      expr1 - expr2
    end
  end
  
  module Comparator
  end
  
  class Equal < Treetop::Runtime::SyntaxNode
    def value(expr1, expr2)
      expr1 == expr2
    end
  end
  
  class NotEqual < Treetop::Runtime::SyntaxNode
    def value(expr1, expr2)
      expr1 != expr2
    end
  end
  
  class LessThan < Treetop::Runtime::SyntaxNode
    def value(expr1, expr2)
      expr1 < expr2
    end
  end
  
  class LessThanOrEqual < Treetop::Runtime::SyntaxNode
    def value(expr1, expr2)
      expr1 <= expr2
    end
  end
  
  class GreaterThan < Treetop::Runtime::SyntaxNode
    def value(expr1, expr2)
      expr1 > expr2
    end
  end
  
  class GreaterThanOrEqual < Treetop::Runtime::SyntaxNode
    def value(expr1, expr2)
      expr1 >= expr2
    end
  end
  
  class String < Treetop::Runtime::SyntaxNode
    def value(root, symbols)
      @value ||= eval(text_value)
    end
  end
  
  class Number < Treetop::Runtime::SyntaxNode
    def value(root, symbols)
      @value ||= eval(text_value)
    end
  end
  
  module Boolean
    def value(root, symbols)
      data.value
    end
  end
  
  class True < Treetop::Runtime::SyntaxNode
    def value(root, symbols)
      true
    end
  end
  
  class False < Treetop::Runtime::SyntaxNode
    def value(root, symbols)
      false
    end
  end
  
  class Null < Treetop::Runtime::SyntaxNode
    def value(root, symbols)
      nil
    end
  end
  
end

