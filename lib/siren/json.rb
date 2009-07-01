module Siren
  module Json
    include Treetop::Runtime

    def root
      @root || :value
    end

    module Value0
      def space
        elements[0]
      end

      def data
        elements[1]
      end

      def space
        elements[2]
      end
    end

    module Value1
      def value
        data.value
      end
    end

    def _nt_value
      start_index = index
      if node_cache[:value].has_key?(index)
        cached = node_cache[:value][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0, s0 = index, []
      r1 = _nt_space
      s0 << r1
      if r1
        i2 = index
        r3 = _nt_object
        if r3
          r2 = r3
        else
          r4 = _nt_array
          if r4
            r2 = r4
          else
            r5 = _nt_string
            if r5
              r2 = r5
            else
              r6 = _nt_number
              if r6
                r2 = r6
              else
                r7 = _nt_true
                if r7
                  r2 = r7
                else
                  r8 = _nt_false
                  if r8
                    r2 = r8
                  else
                    r9 = _nt_null
                    if r9
                      r2 = r9
                    else
                      self.index = i2
                      r2 = nil
                    end
                  end
                end
              end
            end
          end
        end
        s0 << r2
        if r2
          r10 = _nt_space
          s0 << r10
        end
      end
      if s0.last
        r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
        r0.extend(Value0)
        r0.extend(Value1)
      else
        self.index = i0
        r0 = nil
      end

      node_cache[:value][start_index] = r0

      return r0
    end

    module Object0
      def key_value_pair
        elements[1]
      end
    end

    module Object1
      def first
        elements[0]
      end

      def others
        elements[1]
      end
    end

    module Object2
      def space
        elements[1]
      end

      def list
        elements[2]
      end

    end

    module Object3
      def value
        pairs = [list.first] + list.others.elements.map { |e| e.key_value_pair }
        pairs.inject({}) do |hash, pair|
          hash[pair.string.value] = pair.value.value
          hash
        end
      rescue
        {}
      end
    end

    def _nt_object
      start_index = index
      if node_cache[:object].has_key?(index)
        cached = node_cache[:object][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0, s0 = index, []
      if input.index("{", index) == index
        r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("{")
        r1 = nil
      end
      s0 << r1
      if r1
        r2 = _nt_space
        s0 << r2
        if r2
          i4, s4 = index, []
          r5 = _nt_key_value_pair
          s4 << r5
          if r5
            s6, i6 = [], index
            loop do
              i7, s7 = index, []
              if input.index(",", index) == index
                r8 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure(",")
                r8 = nil
              end
              s7 << r8
              if r8
                r9 = _nt_key_value_pair
                s7 << r9
              end
              if s7.last
                r7 = instantiate_node(SyntaxNode,input, i7...index, s7)
                r7.extend(Object0)
              else
                self.index = i7
                r7 = nil
              end
              if r7
                s6 << r7
              else
                break
              end
            end
            r6 = instantiate_node(SyntaxNode,input, i6...index, s6)
            s4 << r6
          end
          if s4.last
            r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
            r4.extend(Object1)
          else
            self.index = i4
            r4 = nil
          end
          if r4
            r3 = r4
          else
            r3 = instantiate_node(SyntaxNode,input, index...index)
          end
          s0 << r3
          if r3
            if input.index("}", index) == index
              r10 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure("}")
              r10 = nil
            end
            s0 << r10
          end
        end
      end
      if s0.last
        r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
        r0.extend(Object2)
        r0.extend(Object3)
      else
        self.index = i0
        r0 = nil
      end

      node_cache[:object][start_index] = r0

      return r0
    end

    module KeyValuePair0
      def space
        elements[0]
      end

      def string
        elements[1]
      end

      def space
        elements[2]
      end

      def value
        elements[4]
      end
    end

    def _nt_key_value_pair
      start_index = index
      if node_cache[:key_value_pair].has_key?(index)
        cached = node_cache[:key_value_pair][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0, s0 = index, []
      r1 = _nt_space
      s0 << r1
      if r1
        r2 = _nt_string
        s0 << r2
        if r2
          r3 = _nt_space
          s0 << r3
          if r3
            if input.index(":", index) == index
              r4 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure(":")
              r4 = nil
            end
            s0 << r4
            if r4
              r5 = _nt_value
              s0 << r5
            end
          end
        end
      end
      if s0.last
        r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
        r0.extend(KeyValuePair0)
      else
        self.index = i0
        r0 = nil
      end

      node_cache[:key_value_pair][start_index] = r0

      return r0
    end

    module Array0
      def value
        elements[1]
      end
    end

    module Array1
      def first
        elements[0]
      end

      def others
        elements[1]
      end
    end

    module Array2
      def space
        elements[1]
      end

      def list
        elements[2]
      end

    end

    module Array3
      def value
        [list.first.value] + list.others.elements.map { |v| v.value.value }
      rescue
        []
      end
    end

    def _nt_array
      start_index = index
      if node_cache[:array].has_key?(index)
        cached = node_cache[:array][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0, s0 = index, []
      if input.index("[", index) == index
        r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("[")
        r1 = nil
      end
      s0 << r1
      if r1
        r2 = _nt_space
        s0 << r2
        if r2
          i4, s4 = index, []
          r5 = _nt_value
          s4 << r5
          if r5
            s6, i6 = [], index
            loop do
              i7, s7 = index, []
              if input.index(",", index) == index
                r8 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure(",")
                r8 = nil
              end
              s7 << r8
              if r8
                r9 = _nt_value
                s7 << r9
              end
              if s7.last
                r7 = instantiate_node(SyntaxNode,input, i7...index, s7)
                r7.extend(Array0)
              else
                self.index = i7
                r7 = nil
              end
              if r7
                s6 << r7
              else
                break
              end
            end
            r6 = instantiate_node(SyntaxNode,input, i6...index, s6)
            s4 << r6
          end
          if s4.last
            r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
            r4.extend(Array1)
          else
            self.index = i4
            r4 = nil
          end
          if r4
            r3 = r4
          else
            r3 = instantiate_node(SyntaxNode,input, index...index)
          end
          s0 << r3
          if r3
            if input.index("]", index) == index
              r10 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure("]")
              r10 = nil
            end
            s0 << r10
          end
        end
      end
      if s0.last
        r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
        r0.extend(Array2)
        r0.extend(Array3)
      else
        self.index = i0
        r0 = nil
      end

      node_cache[:array][start_index] = r0

      return r0
    end

    module String0
      def hex
        elements[1]
      end

      def hex
        elements[2]
      end

      def hex
        elements[3]
      end

      def hex
        elements[4]
      end
    end

    module String1
    end

    module String2
    end

    module String3
      def value
        eval(text_value)
      end
    end

    def _nt_string
      start_index = index
      if node_cache[:string].has_key?(index)
        cached = node_cache[:string][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0, s0 = index, []
      if input.index('"', index) == index
        r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure('"')
        r1 = nil
      end
      s0 << r1
      if r1
        s2, i2 = [], index
        loop do
          i3 = index
          i4, s4 = index, []
          if input.index('\\', index) == index
            r5 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('\\')
            r5 = nil
          end
          s4 << r5
          if r5
            i6 = index
            if input.index('"', index) == index
              r7 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure('"')
              r7 = nil
            end
            if r7
              r6 = r7
            else
              if input.index('\\', index) == index
                r8 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure('\\')
                r8 = nil
              end
              if r8
                r6 = r8
              else
                if input.index('/', index) == index
                  r9 = instantiate_node(SyntaxNode,input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure('/')
                  r9 = nil
                end
                if r9
                  r6 = r9
                else
                  if input.index('b', index) == index
                    r10 = instantiate_node(SyntaxNode,input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure('b')
                    r10 = nil
                  end
                  if r10
                    r6 = r10
                  else
                    if input.index('f', index) == index
                      r11 = instantiate_node(SyntaxNode,input, index...(index + 1))
                      @index += 1
                    else
                      terminal_parse_failure('f')
                      r11 = nil
                    end
                    if r11
                      r6 = r11
                    else
                      if input.index('n', index) == index
                        r12 = instantiate_node(SyntaxNode,input, index...(index + 1))
                        @index += 1
                      else
                        terminal_parse_failure('n')
                        r12 = nil
                      end
                      if r12
                        r6 = r12
                      else
                        if input.index('r', index) == index
                          r13 = instantiate_node(SyntaxNode,input, index...(index + 1))
                          @index += 1
                        else
                          terminal_parse_failure('r')
                          r13 = nil
                        end
                        if r13
                          r6 = r13
                        else
                          if input.index('t', index) == index
                            r14 = instantiate_node(SyntaxNode,input, index...(index + 1))
                            @index += 1
                          else
                            terminal_parse_failure('t')
                            r14 = nil
                          end
                          if r14
                            r6 = r14
                          else
                            i15, s15 = index, []
                            if input.index('u', index) == index
                              r16 = instantiate_node(SyntaxNode,input, index...(index + 1))
                              @index += 1
                            else
                              terminal_parse_failure('u')
                              r16 = nil
                            end
                            s15 << r16
                            if r16
                              r17 = _nt_hex
                              s15 << r17
                              if r17
                                r18 = _nt_hex
                                s15 << r18
                                if r18
                                  r19 = _nt_hex
                                  s15 << r19
                                  if r19
                                    r20 = _nt_hex
                                    s15 << r20
                                  end
                                end
                              end
                            end
                            if s15.last
                              r15 = instantiate_node(SyntaxNode,input, i15...index, s15)
                              r15.extend(String0)
                            else
                              self.index = i15
                              r15 = nil
                            end
                            if r15
                              r6 = r15
                            else
                              self.index = i6
                              r6 = nil
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
            s4 << r6
          end
          if s4.last
            r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
            r4.extend(String1)
          else
            self.index = i4
            r4 = nil
          end
          if r4
            r3 = r4
          else
            if input.index(Regexp.new('[^\\"\\\\]'), index) == index
              r21 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              r21 = nil
            end
            if r21
              r3 = r21
            else
              self.index = i3
              r3 = nil
            end
          end
          if r3
            s2 << r3
          else
            break
          end
        end
        r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
        s0 << r2
        if r2
          if input.index('"', index) == index
            r22 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('"')
            r22 = nil
          end
          s0 << r22
        end
      end
      if s0.last
        r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
        r0.extend(String2)
        r0.extend(String3)
      else
        self.index = i0
        r0 = nil
      end

      node_cache[:string][start_index] = r0

      return r0
    end

    module Number0
    end

    module Number1
    end

    module Number2
    end

    module Number3
    end

    module Number4
      def value
        eval(text_value)
      end
    end

    def _nt_number
      start_index = index
      if node_cache[:number].has_key?(index)
        cached = node_cache[:number][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0, s0 = index, []
      if input.index("-", index) == index
        r2 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("-")
        r2 = nil
      end
      if r2
        r1 = r2
      else
        r1 = instantiate_node(SyntaxNode,input, index...index)
      end
      s0 << r1
      if r1
        i3 = index
        if input.index("0", index) == index
          r4 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("0")
          r4 = nil
        end
        if r4
          r3 = r4
        else
          i5, s5 = index, []
          if input.index(Regexp.new('[1-9]'), index) == index
            r6 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            r6 = nil
          end
          s5 << r6
          if r6
            s7, i7 = [], index
            loop do
              r8 = _nt_digit
              if r8
                s7 << r8
              else
                break
              end
            end
            r7 = instantiate_node(SyntaxNode,input, i7...index, s7)
            s5 << r7
          end
          if s5.last
            r5 = instantiate_node(SyntaxNode,input, i5...index, s5)
            r5.extend(Number0)
          else
            self.index = i5
            r5 = nil
          end
          if r5
            r3 = r5
          else
            self.index = i3
            r3 = nil
          end
        end
        s0 << r3
        if r3
          i10, s10 = index, []
          if input.index(".", index) == index
            r11 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure(".")
            r11 = nil
          end
          s10 << r11
          if r11
            s12, i12 = [], index
            loop do
              r13 = _nt_digit
              if r13
                s12 << r13
              else
                break
              end
            end
            if s12.empty?
              self.index = i12
              r12 = nil
            else
              r12 = instantiate_node(SyntaxNode,input, i12...index, s12)
            end
            s10 << r12
          end
          if s10.last
            r10 = instantiate_node(SyntaxNode,input, i10...index, s10)
            r10.extend(Number1)
          else
            self.index = i10
            r10 = nil
          end
          if r10
            r9 = r10
          else
            r9 = instantiate_node(SyntaxNode,input, index...index)
          end
          s0 << r9
          if r9
            i15, s15 = index, []
            if input.index(Regexp.new('[eE]'), index) == index
              r16 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              r16 = nil
            end
            s15 << r16
            if r16
              if input.index(Regexp.new('[+-]'), index) == index
                r18 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                r18 = nil
              end
              if r18
                r17 = r18
              else
                r17 = instantiate_node(SyntaxNode,input, index...index)
              end
              s15 << r17
              if r17
                s19, i19 = [], index
                loop do
                  r20 = _nt_digit
                  if r20
                    s19 << r20
                  else
                    break
                  end
                end
                if s19.empty?
                  self.index = i19
                  r19 = nil
                else
                  r19 = instantiate_node(SyntaxNode,input, i19...index, s19)
                end
                s15 << r19
              end
            end
            if s15.last
              r15 = instantiate_node(SyntaxNode,input, i15...index, s15)
              r15.extend(Number2)
            else
              self.index = i15
              r15 = nil
            end
            if r15
              r14 = r15
            else
              r14 = instantiate_node(SyntaxNode,input, index...index)
            end
            s0 << r14
          end
        end
      end
      if s0.last
        r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
        r0.extend(Number3)
        r0.extend(Number4)
      else
        self.index = i0
        r0 = nil
      end

      node_cache[:number][start_index] = r0

      return r0
    end

    def _nt_digit
      start_index = index
      if node_cache[:digit].has_key?(index)
        cached = node_cache[:digit][index]
        @index = cached.interval.end if cached
        return cached
      end

      if input.index(Regexp.new('[0-9]'), index) == index
        r0 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        r0 = nil
      end

      node_cache[:digit][start_index] = r0

      return r0
    end

    def _nt_hex
      start_index = index
      if node_cache[:hex].has_key?(index)
        cached = node_cache[:hex][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0 = index
      if input.index(Regexp.new('[a-f]'), index) == index
        r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        r1 = nil
      end
      if r1
        r0 = r1
      else
        r2 = _nt_digit
        if r2
          r0 = r2
        else
          self.index = i0
          r0 = nil
        end
      end

      node_cache[:hex][start_index] = r0

      return r0
    end

    module True0
      def value; true; end
    end

    def _nt_true
      start_index = index
      if node_cache[:true].has_key?(index)
        cached = node_cache[:true][index]
        @index = cached.interval.end if cached
        return cached
      end

      if input.index("true", index) == index
        r0 = instantiate_node(SyntaxNode,input, index...(index + 4))
        r0.extend(True0)
        @index += 4
      else
        terminal_parse_failure("true")
        r0 = nil
      end

      node_cache[:true][start_index] = r0

      return r0
    end

    module False0
      def value; false; end
    end

    def _nt_false
      start_index = index
      if node_cache[:false].has_key?(index)
        cached = node_cache[:false][index]
        @index = cached.interval.end if cached
        return cached
      end

      if input.index("false", index) == index
        r0 = instantiate_node(SyntaxNode,input, index...(index + 5))
        r0.extend(False0)
        @index += 5
      else
        terminal_parse_failure("false")
        r0 = nil
      end

      node_cache[:false][start_index] = r0

      return r0
    end

    module Null0
      def value; nil; end
    end

    def _nt_null
      start_index = index
      if node_cache[:null].has_key?(index)
        cached = node_cache[:null][index]
        @index = cached.interval.end if cached
        return cached
      end

      if input.index("null", index) == index
        r0 = instantiate_node(SyntaxNode,input, index...(index + 4))
        r0.extend(Null0)
        @index += 4
      else
        terminal_parse_failure("null")
        r0 = nil
      end

      node_cache[:null][start_index] = r0

      return r0
    end

    def _nt_space
      start_index = index
      if node_cache[:space].has_key?(index)
        cached = node_cache[:space][index]
        @index = cached.interval.end if cached
        return cached
      end

      s0, i0 = [], index
      loop do
        if input.index(Regexp.new('[\\s\\n\\t]'), index) == index
          r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          r1 = nil
        end
        if r1
          s0 << r1
        else
          break
        end
      end
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)

      node_cache[:space][start_index] = r0

      return r0
    end

  end

  class JsonParser < Treetop::Runtime::CompiledParser
    include Json
  end

end

