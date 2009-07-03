module Siren
  module JsonQuery
    
    module Query
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
    
    module Root
      def value(root, symbols, current = nil)
        root
      end
    end
    
    module Current
      def value(root, symbols, current = nil)
        current
      end
    end
    
    module Symbol
      def value(root, symbols, current = nil)
        symbols[text_value] || FieldAccess.access(current, text_value)
      end
    end
    
    module Filter
    end
    
    module SliceAccess
      def value(object, root, symbols, current = nil)
        a, b = *[head, tail].map { |x| x.value(root, symbols, current) }
        s = step.respond_to?(:number) ? step.number.value(root, symbols, current) : 1
        result = []
        while a <= b
          result << object[a]
          a += s
        end
        result
      end
    end
    
    module RecursiveAccess
      def value(object, root, symbols, current = nil)
        name = elements[1].text_value
        results, visited = [], Set.new
        
        visitor = lambda do |visitee|
          return unless visited.add?(visitee)
          Siren.each(visitee) do |index, value|
            results << value if index == name
            visitor.call(value)
          end
        end
        
        visitor.call(object)
        results
      end
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
            FieldAccess.access(object, indexes.first) :
            indexes.map { |i| FieldAccess.access(object, i) }
      end
      
      def self.access(object, index)
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
    
    module FieldAccessExpression
      def value(root, symbols, current = nil)
        exprs = [first] + others.elements.map { |e| e.expression }
        exprs.map { |e| e.value(root, symbols, current) }
      end
    end
    
    module AllFilter
      def value(root, symbols, current = nil)
        [:*]
      end
    end
    
    module BooleanFilter
      def value(list, root, symbols, current = nil)
        results, visited = [], Set.new
        
        visitor = lambda do |visitee|
          return unless visited.add?(visitee)
          Siren.each(visitee) do |index, value|
            begin
              results << value if boolean_expression.value(root, symbols, value)
            rescue
            end
            visitor.call(value) if recursive.text_value == '..'
          end
        end
        
        visitor.call(list)
        results
      end
    end
    
    module MapFilter
      def value(list, root, symbols, current = nil)
        list.map do |object|
          expression.value(root, symbols, object)
        end
      end
    end
    
    module SortFilter
      def value(list, root, symbols, current = nil)
        sorters = [[first.expression, first.sorter]] +
                  others.elements.map { |e| [e.expression, e.sorter] }
        
        list.sort do |a, b|
          sorters.inject(0) do |outcome, sorter|
            if outcome.nonzero?
              outcome
            else
              f, g = sorter[0].value(root, symbols, a), sorter[0].value(root, symbols, b)
              sorter[1].value * (f <=> g)
            end
          end
        end
      end
    end
    
    module Sorter
      ORDERS = {"/" => 1, "\\" => -1}
      
      def value
        ORDERS[elements[1].text_value]
      end
    end
    
    module And
      def value(root, symbols, current = nil)
        first.value(root, symbols, current) && second.value(root, symbols, current)
      end
    end
    
    module Or
      def value(root, symbols, current = nil)
        first.value(root, symbols, current) || second.value(root, symbols, current)
      end
    end
    
    module Comparison
      def value(root, symbols, current = nil)
        comparator.value(first.value(root, symbols, current), second.value(root, symbols, current))
      end
    end
    
    module BooleanAtom
      def value(root, symbols, current = nil)
        element = elements[1]
        return element.boolean_expression.value(root, symbols, current) if element.respond_to?(:boolean_expression)
        element.value(root, symbols, current)
      end
    end
    
    module Divmod
      def value(root, symbols, current = nil)
        first.value(root, symbols, current) % second.value(root, symbols, current)
      end
    end
    
    module Product
      def value(root, symbols, current = nil)
        operator.value(first.value(root, symbols, current), second.value(root, symbols, current))
      end
    end
    
    module Sum
      def value(root, symbols, current = nil)
        operator.value(first.value(root, symbols, current), second.value(root, symbols, current))
      end
    end
    
    module Atom
      def value(root, symbols, current = nil)
        element = elements[1]
        return element.expression.value(root, symbols, current) if element.respond_to?(:expression)
        element.value(root, symbols, current)
      end
    end
    
    module Multiplication
      def value(expr1, expr2)
        expr1 * expr2
      end
    end
    
    module Division
      def value(expr1, expr2)
        expr1 / expr2
      end
    end
    
    module Addition
      def value(expr1, expr2)
        String === expr1 || String === expr2 ?
            expr1.to_s + expr2.to_s :
            expr1 + expr2
      end
    end
    
    module Subtraction
      def value(expr1, expr2)
        expr1 - expr2
      end
    end
    
    module Comparator
    end
    
    module Equal
      def value(expr1, expr2)
        expr1 == expr2
      end
    end
    
    module NotEqual
      def value(expr1, expr2)
        expr1 != expr2
      end
    end
    
    module LessThan
      def value(expr1, expr2)
        expr1 < expr2
      end
    end
    
    module LessThanOrEqual
      def value(expr1, expr2)
        expr1 <= expr2
      end
    end
    
    module GreaterThan
      def value(expr1, expr2)
        expr1 > expr2
      end
    end
    
    module GreaterThanOrEqual
      def value(expr1, expr2)
        expr1 >= expr2
      end
    end
    
    module String
      def value(root, symbols, current = nil)
        @value ||= eval(text_value)
      end
    end
    
    module Number
      def value(root, symbols, current = nil)
        @value ||= eval(text_value)
      end
    end
    
    module Boolean
      def value(root, symbols, current = nil)
        data.value
      end
    end
    
    module True
      def value(root, symbols, current = nil)
        true
      end
    end
    
    module False
      def value(root, symbols, current = nil)
        false
      end
    end
    
    module Null
      def value(root, symbols, current = nil)
        nil
      end
    end
    
  end
end

