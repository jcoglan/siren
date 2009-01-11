module JsonQuery
  
  class << self
    attr_accessor :root, :current, :symbols
  end
  
  class Query < Treetop::Runtime::SyntaxNode
    def value(root, symbols)
      object = identifier.value(root, symbols)
      filters.inject(object) { |value, filter| filter.value(value, root, symbols) }
    end
    
    def filters
      @filters ||= elements[1].elements
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
    def index(root, symbols)
      element = elements[1]
      return element.text_value if respond_to?(:symbol)
      element.elements[1].value(root, symbols)
    end
    
    def value(object, root, symbols)
      index = index(root, symbols)
      return object[index] if Array === object
      if Hash === object
        key = [index, index.to_s, index.to_sym].find { |i| object.has_key?(i) }
        return object[key] if key
      end
      return object.__send__(index) if object.respond_to?(index)
      object.instance_variable_get("@#{ index }")
    end
  end
  
  class BooleanFilter < Treetop::Runtime::SyntaxNode
    def value(list, root, symbols)
      present, results = JsonQuery.current, list.select do |object|
        JsonQuery.current = object
        boolean_expression.value(root, symbols)
      end
      JsonQuery.current = present
      results
    end
  end
  
  module BooleanExpression
    def value(root, symbols)
      return boolean_expression.value(root, symbols) if respond_to?(:boolean_expression)
      comparator.value(first.value(root, symbols), second.value(root, symbols))
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

