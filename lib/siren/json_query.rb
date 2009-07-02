module Siren
  module JsonQuery
    include Treetop::Runtime

    def root
      @root || :expression
    end

    def _nt_expression
      start_index = index
      if node_cache[:expression].has_key?(index)
        cached = node_cache[:expression][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0 = index
      r1 = _nt_sum
      if r1
        r0 = r1
      else
        r2 = _nt_product
        if r2
          r0 = r2
        else
          r3 = _nt_divmod
          if r3
            r0 = r3
          else
            r4 = _nt_atom
            if r4
              r0 = r4
            else
              self.index = i0
              r0 = nil
            end
          end
        end
      end

      node_cache[:expression][start_index] = r0

      return r0
    end

    def _nt_boolean_expression
      start_index = index
      if node_cache[:boolean_expression].has_key?(index)
        cached = node_cache[:boolean_expression][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0 = index
      r1 = _nt_or_expression
      if r1
        r0 = r1
      else
        r2 = _nt_and_expression
        if r2
          r0 = r2
        else
          r3 = _nt_comparison
          if r3
            r0 = r3
          else
            r4 = _nt_boolean_atom
            if r4
              r0 = r4
            else
              self.index = i0
              r0 = nil
            end
          end
        end
      end

      node_cache[:boolean_expression][start_index] = r0

      return r0
    end

    module OrExpression0
      def first
        elements[0]
      end

      def second
        elements[2]
      end
    end

    def _nt_or_expression
      start_index = index
      if node_cache[:or_expression].has_key?(index)
        cached = node_cache[:or_expression][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0 = index
      i1, s1 = index, []
      r2 = _nt_and_expression
      s1 << r2
      if r2
        if input.index("|", index) == index
          r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("|")
          r3 = nil
        end
        s1 << r3
        if r3
          r4 = _nt_or_expression
          s1 << r4
        end
      end
      if s1.last
        r1 = instantiate_node(Or,input, i1...index, s1)
        r1.extend(OrExpression0)
      else
        self.index = i1
        r1 = nil
      end
      if r1
        r0 = r1
      else
        r5 = _nt_and_expression
        if r5
          r0 = r5
        else
          self.index = i0
          r0 = nil
        end
      end

      node_cache[:or_expression][start_index] = r0

      return r0
    end

    module AndExpression0
      def first
        elements[0]
      end

      def second
        elements[2]
      end
    end

    def _nt_and_expression
      start_index = index
      if node_cache[:and_expression].has_key?(index)
        cached = node_cache[:and_expression][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0 = index
      i1, s1 = index, []
      r2 = _nt_comparison
      s1 << r2
      if r2
        if input.index("&", index) == index
          r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("&")
          r3 = nil
        end
        s1 << r3
        if r3
          r4 = _nt_and_expression
          s1 << r4
        end
      end
      if s1.last
        r1 = instantiate_node(And,input, i1...index, s1)
        r1.extend(AndExpression0)
      else
        self.index = i1
        r1 = nil
      end
      if r1
        r0 = r1
      else
        r5 = _nt_comparison
        if r5
          r0 = r5
        else
          self.index = i0
          r0 = nil
        end
      end

      node_cache[:and_expression][start_index] = r0

      return r0
    end

    module Comparison0
      def first
        elements[0]
      end

      def comparator
        elements[1]
      end

      def second
        elements[2]
      end
    end

    def _nt_comparison
      start_index = index
      if node_cache[:comparison].has_key?(index)
        cached = node_cache[:comparison][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0 = index
      i1, s1 = index, []
      r2 = _nt_expression
      s1 << r2
      if r2
        r3 = _nt_comparator
        s1 << r3
        if r3
          r4 = _nt_expression
          s1 << r4
        end
      end
      if s1.last
        r1 = instantiate_node(Comparison,input, i1...index, s1)
        r1.extend(Comparison0)
      else
        self.index = i1
        r1 = nil
      end
      if r1
        r0 = r1
      else
        r5 = _nt_boolean_atom
        if r5
          r0 = r5
        else
          self.index = i0
          r0 = nil
        end
      end

      node_cache[:comparison][start_index] = r0

      return r0
    end

    module BooleanAtom0
      def boolean_expression
        elements[1]
      end

    end

    module BooleanAtom1
      def space
        elements[0]
      end

      def space
        elements[2]
      end
    end

    def _nt_boolean_atom
      start_index = index
      if node_cache[:boolean_atom].has_key?(index)
        cached = node_cache[:boolean_atom][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0, s0 = index, []
      r1 = _nt_space
      s0 << r1
      if r1
        i2 = index
        i3, s3 = index, []
        if input.index("(", index) == index
          r4 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("(")
          r4 = nil
        end
        s3 << r4
        if r4
          r5 = _nt_boolean_expression
          s3 << r5
          if r5
            if input.index(")", index) == index
              r6 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure(")")
              r6 = nil
            end
            s3 << r6
          end
        end
        if s3.last
          r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
          r3.extend(BooleanAtom0)
        else
          self.index = i3
          r3 = nil
        end
        if r3
          r2 = r3
        else
          r7 = _nt_boolean
          if r7
            r2 = r7
          else
            self.index = i2
            r2 = nil
          end
        end
        s0 << r2
        if r2
          r8 = _nt_space
          s0 << r8
        end
      end
      if s0.last
        r0 = instantiate_node(BooleanAtom,input, i0...index, s0)
        r0.extend(BooleanAtom1)
      else
        self.index = i0
        r0 = nil
      end

      node_cache[:boolean_atom][start_index] = r0

      return r0
    end

    module Sum0
      def first
        elements[0]
      end

      def operator
        elements[1]
      end

      def second
        elements[2]
      end
    end

    def _nt_sum
      start_index = index
      if node_cache[:sum].has_key?(index)
        cached = node_cache[:sum][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0 = index
      i1, s1 = index, []
      r2 = _nt_product
      s1 << r2
      if r2
        i3 = index
        r4 = _nt_add
        if r4
          r3 = r4
        else
          r5 = _nt_subtract
          if r5
            r3 = r5
          else
            self.index = i3
            r3 = nil
          end
        end
        s1 << r3
        if r3
          r6 = _nt_sum
          s1 << r6
        end
      end
      if s1.last
        r1 = instantiate_node(Sum,input, i1...index, s1)
        r1.extend(Sum0)
      else
        self.index = i1
        r1 = nil
      end
      if r1
        r0 = r1
      else
        r7 = _nt_product
        if r7
          r0 = r7
        else
          self.index = i0
          r0 = nil
        end
      end

      node_cache[:sum][start_index] = r0

      return r0
    end

    module Product0
      def first
        elements[0]
      end

      def operator
        elements[1]
      end

      def second
        elements[2]
      end
    end

    def _nt_product
      start_index = index
      if node_cache[:product].has_key?(index)
        cached = node_cache[:product][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0 = index
      i1, s1 = index, []
      r2 = _nt_divmod
      s1 << r2
      if r2
        i3 = index
        r4 = _nt_times
        if r4
          r3 = r4
        else
          r5 = _nt_divide
          if r5
            r3 = r5
          else
            self.index = i3
            r3 = nil
          end
        end
        s1 << r3
        if r3
          r6 = _nt_product
          s1 << r6
        end
      end
      if s1.last
        r1 = instantiate_node(Product,input, i1...index, s1)
        r1.extend(Product0)
      else
        self.index = i1
        r1 = nil
      end
      if r1
        r0 = r1
      else
        r7 = _nt_divmod
        if r7
          r0 = r7
        else
          self.index = i0
          r0 = nil
        end
      end

      node_cache[:product][start_index] = r0

      return r0
    end

    module Divmod0
      def first
        elements[0]
      end

      def second
        elements[2]
      end
    end

    def _nt_divmod
      start_index = index
      if node_cache[:divmod].has_key?(index)
        cached = node_cache[:divmod][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0 = index
      i1, s1 = index, []
      r2 = _nt_atom
      s1 << r2
      if r2
        if input.index('%', index) == index
          r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('%')
          r3 = nil
        end
        s1 << r3
        if r3
          r4 = _nt_divmod
          s1 << r4
        end
      end
      if s1.last
        r1 = instantiate_node(Divmod,input, i1...index, s1)
        r1.extend(Divmod0)
      else
        self.index = i1
        r1 = nil
      end
      if r1
        r0 = r1
      else
        r5 = _nt_atom
        if r5
          r0 = r5
        else
          self.index = i0
          r0 = nil
        end
      end

      node_cache[:divmod][start_index] = r0

      return r0
    end

    module Atom0
      def expression
        elements[1]
      end

    end

    module Atom1
      def space
        elements[0]
      end

      def space
        elements[2]
      end
    end

    def _nt_atom
      start_index = index
      if node_cache[:atom].has_key?(index)
        cached = node_cache[:atom][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0, s0 = index, []
      r1 = _nt_space
      s0 << r1
      if r1
        i2 = index
        i3, s3 = index, []
        if input.index("(", index) == index
          r4 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("(")
          r4 = nil
        end
        s3 << r4
        if r4
          r5 = _nt_expression
          s3 << r5
          if r5
            if input.index(")", index) == index
              r6 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure(")")
              r6 = nil
            end
            s3 << r6
          end
        end
        if s3.last
          r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
          r3.extend(Atom0)
        else
          self.index = i3
          r3 = nil
        end
        if r3
          r2 = r3
        else
          r7 = _nt_query
          if r7
            r2 = r7
          else
            r8 = _nt_number
            if r8
              r2 = r8
            else
              r9 = _nt_string
              if r9
                r2 = r9
              else
                r10 = _nt_boolean
                if r10
                  r2 = r10
                else
                  r11 = _nt_null
                  if r11
                    r2 = r11
                  else
                    self.index = i2
                    r2 = nil
                  end
                end
              end
            end
          end
        end
        s0 << r2
        if r2
          r12 = _nt_space
          s0 << r12
        end
      end
      if s0.last
        r0 = instantiate_node(Atom,input, i0...index, s0)
        r0.extend(Atom1)
      else
        self.index = i0
        r0 = nil
      end

      node_cache[:atom][start_index] = r0

      return r0
    end

    def _nt_times
      start_index = index
      if node_cache[:times].has_key?(index)
        cached = node_cache[:times][index]
        @index = cached.interval.end if cached
        return cached
      end

      if input.index("*", index) == index
        r0 = instantiate_node(Multiplication,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("*")
        r0 = nil
      end

      node_cache[:times][start_index] = r0

      return r0
    end

    def _nt_divide
      start_index = index
      if node_cache[:divide].has_key?(index)
        cached = node_cache[:divide][index]
        @index = cached.interval.end if cached
        return cached
      end

      if input.index("/", index) == index
        r0 = instantiate_node(Division,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("/")
        r0 = nil
      end

      node_cache[:divide][start_index] = r0

      return r0
    end

    def _nt_add
      start_index = index
      if node_cache[:add].has_key?(index)
        cached = node_cache[:add][index]
        @index = cached.interval.end if cached
        return cached
      end

      if input.index("+", index) == index
        r0 = instantiate_node(Addition,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("+")
        r0 = nil
      end

      node_cache[:add][start_index] = r0

      return r0
    end

    def _nt_subtract
      start_index = index
      if node_cache[:subtract].has_key?(index)
        cached = node_cache[:subtract][index]
        @index = cached.interval.end if cached
        return cached
      end

      if input.index("-", index) == index
        r0 = instantiate_node(Subtraction,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("-")
        r0 = nil
      end

      node_cache[:subtract][start_index] = r0

      return r0
    end

    def _nt_comparator
      start_index = index
      if node_cache[:comparator].has_key?(index)
        cached = node_cache[:comparator][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0 = index
      r1 = _nt_not_equal
      if r1
        r0 = r1
        r0.extend(Comparator)
      else
        r2 = _nt_lte
        if r2
          r0 = r2
          r0.extend(Comparator)
        else
          r3 = _nt_gte
          if r3
            r0 = r3
            r0.extend(Comparator)
          else
            r4 = _nt_equal
            if r4
              r0 = r4
              r0.extend(Comparator)
            else
              r5 = _nt_lt
              if r5
                r0 = r5
                r0.extend(Comparator)
              else
                r6 = _nt_gt
                if r6
                  r0 = r6
                  r0.extend(Comparator)
                else
                  self.index = i0
                  r0 = nil
                end
              end
            end
          end
        end
      end

      node_cache[:comparator][start_index] = r0

      return r0
    end

    def _nt_equal
      start_index = index
      if node_cache[:equal].has_key?(index)
        cached = node_cache[:equal][index]
        @index = cached.interval.end if cached
        return cached
      end

      if input.index("=", index) == index
        r0 = instantiate_node(Equal,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("=")
        r0 = nil
      end

      node_cache[:equal][start_index] = r0

      return r0
    end

    def _nt_not_equal
      start_index = index
      if node_cache[:not_equal].has_key?(index)
        cached = node_cache[:not_equal][index]
        @index = cached.interval.end if cached
        return cached
      end

      if input.index("!=", index) == index
        r0 = instantiate_node(NotEqual,input, index...(index + 2))
        @index += 2
      else
        terminal_parse_failure("!=")
        r0 = nil
      end

      node_cache[:not_equal][start_index] = r0

      return r0
    end

    def _nt_lt
      start_index = index
      if node_cache[:lt].has_key?(index)
        cached = node_cache[:lt][index]
        @index = cached.interval.end if cached
        return cached
      end

      if input.index("<", index) == index
        r0 = instantiate_node(LessThan,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("<")
        r0 = nil
      end

      node_cache[:lt][start_index] = r0

      return r0
    end

    def _nt_lte
      start_index = index
      if node_cache[:lte].has_key?(index)
        cached = node_cache[:lte][index]
        @index = cached.interval.end if cached
        return cached
      end

      if input.index("<=", index) == index
        r0 = instantiate_node(LessThanOrEqual,input, index...(index + 2))
        @index += 2
      else
        terminal_parse_failure("<=")
        r0 = nil
      end

      node_cache[:lte][start_index] = r0

      return r0
    end

    def _nt_gt
      start_index = index
      if node_cache[:gt].has_key?(index)
        cached = node_cache[:gt][index]
        @index = cached.interval.end if cached
        return cached
      end

      if input.index(">", index) == index
        r0 = instantiate_node(GreaterThan,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure(">")
        r0 = nil
      end

      node_cache[:gt][start_index] = r0

      return r0
    end

    def _nt_gte
      start_index = index
      if node_cache[:gte].has_key?(index)
        cached = node_cache[:gte][index]
        @index = cached.interval.end if cached
        return cached
      end

      if input.index(">=", index) == index
        r0 = instantiate_node(GreaterThanOrEqual,input, index...(index + 2))
        @index += 2
      else
        terminal_parse_failure(">=")
        r0 = nil
      end

      node_cache[:gte][start_index] = r0

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

    def _nt_string
      start_index = index
      if node_cache[:string].has_key?(index)
        cached = node_cache[:string][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0, s0 = index, []
      if input.index("'", index) == index
        r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("'")
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
            if input.index("'", index) == index
              r7 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure("'")
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
            if input.index(Regexp.new('[^\\\'\\\\]'), index) == index
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
          if input.index("'", index) == index
            r22 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure("'")
            r22 = nil
          end
          s0 << r22
        end
      end
      if s0.last
        r0 = instantiate_node(String,input, i0...index, s0)
        r0.extend(String2)
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
        r0 = instantiate_node(Number,input, i0...index, s0)
        r0.extend(Number3)
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

    def _nt_boolean
      start_index = index
      if node_cache[:boolean].has_key?(index)
        cached = node_cache[:boolean][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0 = index
      r1 = _nt_true
      if r1
        r0 = r1
        r0.extend(Boolean)
      else
        r2 = _nt_false
        if r2
          r0 = r2
          r0.extend(Boolean)
        else
          self.index = i0
          r0 = nil
        end
      end

      node_cache[:boolean][start_index] = r0

      return r0
    end

    def _nt_true
      start_index = index
      if node_cache[:true].has_key?(index)
        cached = node_cache[:true][index]
        @index = cached.interval.end if cached
        return cached
      end

      if input.index("true", index) == index
        r0 = instantiate_node(True,input, index...(index + 4))
        @index += 4
      else
        terminal_parse_failure("true")
        r0 = nil
      end

      node_cache[:true][start_index] = r0

      return r0
    end

    def _nt_false
      start_index = index
      if node_cache[:false].has_key?(index)
        cached = node_cache[:false][index]
        @index = cached.interval.end if cached
        return cached
      end

      if input.index("false", index) == index
        r0 = instantiate_node(False,input, index...(index + 5))
        @index += 5
      else
        terminal_parse_failure("false")
        r0 = nil
      end

      node_cache[:false][start_index] = r0

      return r0
    end

    def _nt_null
      start_index = index
      if node_cache[:null].has_key?(index)
        cached = node_cache[:null][index]
        @index = cached.interval.end if cached
        return cached
      end

      if input.index("null", index) == index
        r0 = instantiate_node(Null,input, index...(index + 4))
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
        if input.index(" ", index) == index
          r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure(" ")
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

    module Query0
      def identifier
        elements[0]
      end

    end

    def _nt_query
      start_index = index
      if node_cache[:query].has_key?(index)
        cached = node_cache[:query][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0, s0 = index, []
      r1 = _nt_identifier
      s0 << r1
      if r1
        s2, i2 = [], index
        loop do
          r3 = _nt_filter
          if r3
            s2 << r3
          else
            break
          end
        end
        r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
        s0 << r2
      end
      if s0.last
        r0 = instantiate_node(Query,input, i0...index, s0)
        r0.extend(Query0)
      else
        self.index = i0
        r0 = nil
      end

      node_cache[:query][start_index] = r0

      return r0
    end

    def _nt_identifier
      start_index = index
      if node_cache[:identifier].has_key?(index)
        cached = node_cache[:identifier][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0 = index
      r1 = _nt_root
      if r1
        r0 = r1
        r0.extend(Identifier)
      else
        r2 = _nt_current
        if r2
          r0 = r2
          r0.extend(Identifier)
        else
          r3 = _nt_symbol
          if r3
            r0 = r3
            r0.extend(Identifier)
          else
            self.index = i0
            r0 = nil
          end
        end
      end

      node_cache[:identifier][start_index] = r0

      return r0
    end

    def _nt_root
      start_index = index
      if node_cache[:root].has_key?(index)
        cached = node_cache[:root][index]
        @index = cached.interval.end if cached
        return cached
      end

      if input.index("$", index) == index
        r0 = instantiate_node(Root,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("$")
        r0 = nil
      end

      node_cache[:root][start_index] = r0

      return r0
    end

    def _nt_current
      start_index = index
      if node_cache[:current].has_key?(index)
        cached = node_cache[:current][index]
        @index = cached.interval.end if cached
        return cached
      end

      if input.index("@", index) == index
        r0 = instantiate_node(Current,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("@")
        r0 = nil
      end

      node_cache[:current][start_index] = r0

      return r0
    end

    module Symbol0
    end

    def _nt_symbol
      start_index = index
      if node_cache[:symbol].has_key?(index)
        cached = node_cache[:symbol][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0, s0 = index, []
      if input.index(Regexp.new('[A-Za-z$_]'), index) == index
        r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        r1 = nil
      end
      s0 << r1
      if r1
        s2, i2 = [], index
        loop do
          if input.index(Regexp.new('[A-Za-z0-9$_]'), index) == index
            r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            r3 = nil
          end
          if r3
            s2 << r3
          else
            break
          end
        end
        r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
        s0 << r2
      end
      if s0.last
        r0 = instantiate_node(Symbol,input, i0...index, s0)
        r0.extend(Symbol0)
      else
        self.index = i0
        r0 = nil
      end

      node_cache[:symbol][start_index] = r0

      return r0
    end

    def _nt_filter
      start_index = index
      if node_cache[:filter].has_key?(index)
        cached = node_cache[:filter][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0 = index
      r1 = _nt_slice_access
      if r1
        r0 = r1
        r0.extend(Filter)
      else
        r2 = _nt_field_access
        if r2
          r0 = r2
          r0.extend(Filter)
        else
          r3 = _nt_boolean_filter
          if r3
            r0 = r3
            r0.extend(Filter)
          else
            r4 = _nt_map_filter
            if r4
              r0 = r4
              r0.extend(Filter)
            else
              r5 = _nt_sort_filter
              if r5
                r0 = r5
                r0.extend(Filter)
              else
                self.index = i0
                r0 = nil
              end
            end
          end
        end
      end

      node_cache[:filter][start_index] = r0

      return r0
    end

    module SliceAccess0
      def head
        elements[1]
      end

      def tail
        elements[3]
      end

      def step
        elements[5]
      end

    end

    def _nt_slice_access
      start_index = index
      if node_cache[:slice_access].has_key?(index)
        cached = node_cache[:slice_access][index]
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
        r2 = _nt_number
        s0 << r2
        if r2
          if input.index(":", index) == index
            r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure(":")
            r3 = nil
          end
          s0 << r3
          if r3
            r4 = _nt_number
            s0 << r4
            if r4
              if input.index(":", index) == index
                r5 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure(":")
                r5 = nil
              end
              s0 << r5
              if r5
                r6 = _nt_number
                s0 << r6
                if r6
                  if input.index("]", index) == index
                    r7 = instantiate_node(SyntaxNode,input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure("]")
                    r7 = nil
                  end
                  s0 << r7
                end
              end
            end
          end
        end
      end
      if s0.last
        r0 = instantiate_node(SliceAccess,input, i0...index, s0)
        r0.extend(SliceAccess0)
      else
        self.index = i0
        r0 = nil
      end

      node_cache[:slice_access][start_index] = r0

      return r0
    end

    module FieldAccess0
    end

    module FieldAccess1
    end

    def _nt_field_access
      start_index = index
      if node_cache[:field_access].has_key?(index)
        cached = node_cache[:field_access][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0 = index
      i1, s1 = index, []
      if input.index(".", index) == index
        r2 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure(".")
        r2 = nil
      end
      s1 << r2
      if r2
        i3 = index
        r4 = _nt_symbol
        if r4
          r3 = r4
        else
          r5 = _nt_all
          if r5
            r3 = r5
          else
            self.index = i3
            r3 = nil
          end
        end
        s1 << r3
      end
      if s1.last
        r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
        r1.extend(FieldAccess0)
      else
        self.index = i1
        r1 = nil
      end
      if r1
        r0 = r1
        r0.extend(FieldAccess)
      else
        i6, s6 = index, []
        if input.index("[", index) == index
          r7 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("[")
          r7 = nil
        end
        s6 << r7
        if r7
          i8 = index
          r9 = _nt_field_access_expression
          if r9
            r8 = r9
          else
            r10 = _nt_all
            if r10
              r8 = r10
            else
              self.index = i8
              r8 = nil
            end
          end
          s6 << r8
          if r8
            if input.index("]", index) == index
              r11 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure("]")
              r11 = nil
            end
            s6 << r11
          end
        end
        if s6.last
          r6 = instantiate_node(SyntaxNode,input, i6...index, s6)
          r6.extend(FieldAccess1)
        else
          self.index = i6
          r6 = nil
        end
        if r6
          r0 = r6
          r0.extend(FieldAccess)
        else
          self.index = i0
          r0 = nil
        end
      end

      node_cache[:field_access][start_index] = r0

      return r0
    end

    module FieldAccessExpression0
      def expression
        elements[1]
      end
    end

    module FieldAccessExpression1
      def first
        elements[0]
      end

      def others
        elements[1]
      end
    end

    def _nt_field_access_expression
      start_index = index
      if node_cache[:field_access_expression].has_key?(index)
        cached = node_cache[:field_access_expression][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0, s0 = index, []
      r1 = _nt_expression
      s0 << r1
      if r1
        s2, i2 = [], index
        loop do
          i3, s3 = index, []
          if input.index(",", index) == index
            r4 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure(",")
            r4 = nil
          end
          s3 << r4
          if r4
            r5 = _nt_expression
            s3 << r5
          end
          if s3.last
            r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
            r3.extend(FieldAccessExpression0)
          else
            self.index = i3
            r3 = nil
          end
          if r3
            s2 << r3
          else
            break
          end
        end
        r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
        s0 << r2
      end
      if s0.last
        r0 = instantiate_node(FieldAccessExpression,input, i0...index, s0)
        r0.extend(FieldAccessExpression1)
      else
        self.index = i0
        r0 = nil
      end

      node_cache[:field_access_expression][start_index] = r0

      return r0
    end

    def _nt_all
      start_index = index
      if node_cache[:all].has_key?(index)
        cached = node_cache[:all][index]
        @index = cached.interval.end if cached
        return cached
      end

      if input.index("*", index) == index
        r0 = instantiate_node(AllFilter,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("*")
        r0 = nil
      end

      node_cache[:all][start_index] = r0

      return r0
    end

    module BooleanFilter0
      def boolean_expression
        elements[1]
      end

    end

    def _nt_boolean_filter
      start_index = index
      if node_cache[:boolean_filter].has_key?(index)
        cached = node_cache[:boolean_filter][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0, s0 = index, []
      if input.index("[?", index) == index
        r1 = instantiate_node(SyntaxNode,input, index...(index + 2))
        @index += 2
      else
        terminal_parse_failure("[?")
        r1 = nil
      end
      s0 << r1
      if r1
        r2 = _nt_boolean_expression
        s0 << r2
        if r2
          if input.index("]", index) == index
            r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure("]")
            r3 = nil
          end
          s0 << r3
        end
      end
      if s0.last
        r0 = instantiate_node(BooleanFilter,input, i0...index, s0)
        r0.extend(BooleanFilter0)
      else
        self.index = i0
        r0 = nil
      end

      node_cache[:boolean_filter][start_index] = r0

      return r0
    end

    module MapFilter0
      def expression
        elements[1]
      end

    end

    def _nt_map_filter
      start_index = index
      if node_cache[:map_filter].has_key?(index)
        cached = node_cache[:map_filter][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0, s0 = index, []
      if input.index("[=", index) == index
        r1 = instantiate_node(SyntaxNode,input, index...(index + 2))
        @index += 2
      else
        terminal_parse_failure("[=")
        r1 = nil
      end
      s0 << r1
      if r1
        r2 = _nt_expression
        s0 << r2
        if r2
          if input.index("]", index) == index
            r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure("]")
            r3 = nil
          end
          s0 << r3
        end
      end
      if s0.last
        r0 = instantiate_node(MapFilter,input, i0...index, s0)
        r0.extend(MapFilter0)
      else
        self.index = i0
        r0 = nil
      end

      node_cache[:map_filter][start_index] = r0

      return r0
    end

    module SortFilter0
      def sorter
        elements[0]
      end

      def expression
        elements[1]
      end
    end

    module SortFilter1
      def sorter
        elements[1]
      end

      def expression
        elements[2]
      end
    end

    module SortFilter2
      def first
        elements[1]
      end

      def others
        elements[2]
      end

    end

    def _nt_sort_filter
      start_index = index
      if node_cache[:sort_filter].has_key?(index)
        cached = node_cache[:sort_filter][index]
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
        i2, s2 = index, []
        r3 = _nt_sorter
        s2 << r3
        if r3
          r4 = _nt_expression
          s2 << r4
        end
        if s2.last
          r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
          r2.extend(SortFilter0)
        else
          self.index = i2
          r2 = nil
        end
        s0 << r2
        if r2
          s5, i5 = [], index
          loop do
            i6, s6 = index, []
            if input.index(",", index) == index
              r7 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure(",")
              r7 = nil
            end
            s6 << r7
            if r7
              r8 = _nt_sorter
              s6 << r8
              if r8
                r9 = _nt_expression
                s6 << r9
              end
            end
            if s6.last
              r6 = instantiate_node(SyntaxNode,input, i6...index, s6)
              r6.extend(SortFilter1)
            else
              self.index = i6
              r6 = nil
            end
            if r6
              s5 << r6
            else
              break
            end
          end
          r5 = instantiate_node(SyntaxNode,input, i5...index, s5)
          s0 << r5
          if r5
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
        r0 = instantiate_node(SortFilter,input, i0...index, s0)
        r0.extend(SortFilter2)
      else
        self.index = i0
        r0 = nil
      end

      node_cache[:sort_filter][start_index] = r0

      return r0
    end

    module Sorter0
      def space
        elements[0]
      end

      def space
        elements[2]
      end
    end

    def _nt_sorter
      start_index = index
      if node_cache[:sorter].has_key?(index)
        cached = node_cache[:sorter][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0, s0 = index, []
      r1 = _nt_space
      s0 << r1
      if r1
        i2 = index
        if input.index("/", index) == index
          r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("/")
          r3 = nil
        end
        if r3
          r2 = r3
        else
          if input.index("\\", index) == index
            r4 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure("\\")
            r4 = nil
          end
          if r4
            r2 = r4
          else
            self.index = i2
            r2 = nil
          end
        end
        s0 << r2
        if r2
          r5 = _nt_space
          s0 << r5
        end
      end
      if s0.last
        r0 = instantiate_node(Sorter,input, i0...index, s0)
        r0.extend(Sorter0)
      else
        self.index = i0
        r0 = nil
      end

      node_cache[:sorter][start_index] = r0

      return r0
    end

  end

  class JsonQueryParser < Treetop::Runtime::CompiledParser
    include JsonQuery
  end

end

