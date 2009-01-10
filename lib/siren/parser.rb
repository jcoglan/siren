# Based on http://www.json.org/json_parse.js (public domain)

module Siren
  class Parser
    
    ESCAPEE = {
      '"'   => '"',
      '\\'  => '\\',
      '/'   => '/',
      'b'   => '\b',
      'f'   => '\f',
      'n'   => '\n',
      'r'   => '\r',
      't'   => '\t'
    }
    
    attr_reader :at,     # The index of the current character
                :ch      # The current character
    
    def parse(source, &reviver)
      @text = source.dup
      @at, @ch = 0, ' '
      result = value!
      white!
      error! "Syntax error" if @ch
      
      # If there is a reviver function, we recursively walk the new structure,
      # passing each name/value pair to the reviver function for possible
      # transformation, starting with a temporary root object that holds the result
      # in an empty key. If there is not a reviver function, we simply return the
      # result.
      return result unless block_given?
      
      walk = lambda do |holder, key|
        value = holder[key]
        
        for_each = lambda do |k, val|
          v = walk.call(value, k)
          if v.nil?
            holder.delete(k)
          else
            value[k] = v
          end
        end
        
        value.each { |k,v| for_each.call(k,v) } if Hash === value
        value.each_with_index { |v,i| for_each.call(i,v) } if Array === value
        
        reviver.call(holder, key, value)
      end
      
      walk.call({"" => result}, "")
    end
    
  private
    
    def next!(c = nil)
      # If a c parameter is provided, verify that it matches the current character.
      error! "Expected '#{c}' instead of '#{@ch}'" if c && c != @ch
      
      # Get the next character. When there are no more characters,
      # return the empty string.
      @ch = @text[at].chr rescue nil
      @at += 1
      @ch
    end
    
    # Parse a number value.
    def number!
      string = ''
      if @ch == '-'
        string = '-'
        next!('-')
      end
      while @ch >= '0' && @ch <= '9'
        string += @ch
        next!
      end
      if @ch == '.'
        string += '.'
        while next! && @ch >= '0' && @ch <= '9'
          string += @ch
        end
      end
      if @ch == 'e' || @ch == 'E'
        string += @ch
        next!
        if @ch == '-' || @ch == '+'
          string += @ch
          next!
        end
        while @ch >= '0' && @ch <= '9'
          string += @ch
          next!
        end
      end
      string.to_f
    rescue
      error! "Bad number"
    end
    
    #Parse a string value.
    def string!
      string = ''
      # When parsing for string values, we must look for " and \ characters.
      if @ch == '"'
        while next!
          if @ch == '"'
            next!
            return string
          elsif ch == '\\'
            next!
            if @ch == 'u'
              uffff = 0
              4.times do
                hex = next!.to_i(16)
                uffff = uffff * 16 + hex
              end
              string += uffff.chr
            elsif String === ESCAPPE[@ch]
              string += ESCAPPE[@ch]
            else
              break
            end
          else
            string += @ch
          end
        end
      end
      error! "Bad string"
    end
    
    # Skip whitespace.
    def white!
      next! while @ch && @ch <= ' '
    end
    
    # true, false, undefined or null.
    def word!
      case @ch
        when 't':
          %w(t r u e).each { |c| next!(c) }
          return true
        when 'f':
          %w(f a l s e).each { |c| next!(c) }
          return false
        when 'u':
          %w(u n d e f i n e d).each { |c| next!(c) }
          return nil
        when 'n':
          %w(n u l l).each { |c| next!(c) }
          return nil
      end
      error! "Unexpected '#{@ch}'"
    end
    
    # Parse an array value.
    def array!
      array = []
      
      if @ch == '['
        next!('[')
        white!
        if @ch == ']'
          next!(']')
          return array   # empty array
        end
        while @ch
          array << value!
          white!
          if @ch == ']'
            next!(']')
            return array
          end
          next!(',')
          white!
        end
      end
      error! "Bad array"
    end
    
    # Parse an object value.
    def object!
      object = {}

      if @ch == '{'
        next!('{')
        white!
        if @ch == '}'
          next!('}')
          return object   # empty object
        end
        while @ch
          key = string!
          white!
          next!(':')
          error! 'Duplicate key "#{key}"' if object.has_key?(key)
          object[key] = value!
          white!
          if @ch == '}'
            next!('}')
            return object
          end
          next!(',')
          white!
        end
      end
      error! "Bad object"
    end
    
    # Parse a JSON value. It could be an object, an array, a string, a number,
    # or a word.
    def value!
      white!
      case @ch
        when '{':  object!
        when '[':  array!
        when '"':  string!
        when '-':  number!
        else       @ch >= '0' && @ch <= '9' ? number! : word!
      end
    end
    
    # Call error when something is wrong.
    def error!(message = nil)
      raise Exception
    end
    
  end
end

