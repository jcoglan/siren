module Siren
  module Walker
    
    # If there is a reviver function, we recursively walk the new structure,
    # passing each name/value pair to the reviver function for possible
    # transformation, starting with a temporary root object that holds the result
    # in an empty key. If there is not a reviver function, we simply return the
    # result.
    def walk(data, &reviver)
      data = parse(data) if String === data
      return data unless block_given?
      
      walker = lambda do |holder, key|
        value = holder[key]
        
        for_each = lambda do |k, val|
          v = walker.call(value, k)
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
      
      walker.call({"" => data}, "")
    end
    
  end
end

