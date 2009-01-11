module JsonQuery
  
  class Query < Treetop::Runtime::SyntaxNode
    def value(root, symbols, current = nil)
      object = identifier.value(root, symbols, current)
      filters.inject(object) { |value, filter| filter.value(value, root, symbols, current) }
    end
    
    def filters
      elements[1].elements
    end
  end
  
  module Identifier
  end
  
  class Root < Treetop::Runtime::SyntaxNode
    def value(root, symbols, current = nil)
      root
    end
  end
  
  class Current < Treetop::Runtime::SyntaxNode
    def value(root, symbols, current = nil)
      current
    end
  end
  
  class Symbol < Treetop::Runtime::SyntaxNode
    def value(root, symbols, current = nil)
      symbols[text_value]
    end
  end
  
  module Filter
  end
  
  module FieldAccess
    def index(object, root, symbols, current = nil)
      element = elements[1]
      return [element.text_value] if Symbol === element
      element.value(root, symbols, object)
    end
    
    def value(object, root, symbols, current = nil)
      indexes = index(object, root, symbols, current)
      indexes.size == 1 ?
          access(object, indexes.first) :
          indexes.map { |i| access(object, i) }
    end
    
    def access(object, index)
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
  
  class FieldAccessExpression < Treetop::Runtime::SyntaxNode
    def value(root, symbols, current = nil)
      exprs = [first] + others.elements.map { |e| e.expression }
      exprs.map { |e| e.value(root, symbols, current) }
    end
  end
  
  class AllFilter < Treetop::Runtime::SyntaxNode
    def value(root, symbols, current = nil)
      [:*]
    end
  end
  
  class BooleanFilter < Treetop::Runtime::SyntaxNode
    def value(list, root, symbols, current = nil)
      list.select do |object|
        boolean_expression.value(root, symbols, object)
      end
    end
  end
  
  class And < Treetop::Runtime::SyntaxNode
    def value(root, symbols, current = nil)
      first.value(root, symbols, current) && second.value(root, symbols, current)
    end
  end
  
  class Or < Treetop::Runtime::SyntaxNode
    def value(root, symbols, current = nil)
      first.value(root, symbols, current) || second.value(root, symbols, current)
    end
  end
  
  class BooleanAtom < Treetop::Runtime::SyntaxNode
    def value(root, symbols, current = nil)
      element = elements[1]
      return element.boolean_expression.value(root, symbols, current) if element.respond_to?(:boolean_expression)
      comparator.value(first.value(root, symbols, current), second.value(root, symbols, current))
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
    def value(root, symbols, current = nil)
      operator.value(first.value(root, symbols, current), second.value(root, symbols, current))
    end
  end
  
  class Additive < Treetop::Runtime::SyntaxNode
    def value(root, symbols, current = nil)
      operator.value(first.value(root, symbols, current), second.value(root, symbols, current))
    end
  end
  
  class Atom < Treetop::Runtime::SyntaxNode
    def value(root, symbols, current = nil)
      element = elements[1]
      return element.expression.value(root, symbols, current) if element.respond_to?(:expression)
      element.value(root, symbols, current)
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
    def value(root, symbols, current = nil)
      @value ||= eval(text_value)
    end
  end
  
  class Number < Treetop::Runtime::SyntaxNode
    def value(root, symbols, current = nil)
      @value ||= eval(text_value)
    end
  end
  
  module Boolean
    def value(root, symbols, current = nil)
      data.value
    end
  end
  
  class True < Treetop::Runtime::SyntaxNode
    def value(root, symbols, current = nil)
      true
    end
  end
  
  class False < Treetop::Runtime::SyntaxNode
    def value(root, symbols, current = nil)
      false
    end
  end
  
  class Null < Treetop::Runtime::SyntaxNode
    def value(root, symbols, current = nil)
      nil
    end
  end
  
end

