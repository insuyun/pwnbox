module Pwnbox
  module ECC
    # Eliptic Curve Point
    class Point
      attr_accessor :x, :y

      def initialize(curve, x, y)
        @curve, @x, @y = curve, x, y
      end

      def add(other)
        # Handling zero
        return other.dup if zero?
        return dup if other.zero?

        if inverse?(other)
          @curve.zero
        else
          l = calculate_slope(other)
          n_x, n_y = meeting_point(l, other)
          @curve.point(n_x, n_y)
        end
      end

      def equal?(other)
        @x == other.x && @y == other.y
      end

      def inverse?(other)
        @x == other.x && @y == (-other.y) % @curve.p
      end

      def zero?
        @x == Float::INFINITY && @y == Float::INFINITY
      end

      def to_s
        "{x: #{@x}, y:#{@y}}"
      end

      def inverse
        @curve.point(@x, -@y % @curve.p)
      end

      def mult(k)
        return @curve.zero if (k == 0)

        mul = @curve.zero
        exponent = self

        until k.zero?
          mul = mul.add(exponent) if k.odd?
          exponent = exponent.add(exponent)
          k >>= 1
        end

        mul
      end

      private

      def meeting_point(l, other)
        n_x = (l**2 - @x - other.x) % @curve.p
        n_y = (l * (@x - n_x) - @y) % @curve.p
        [n_x, n_y]
      end

      def slope_when_equal
        (3 * (@x**2) + @curve.a) * Number.mod_inverse(2 * @y, @curve.p)
      end

      def slope_when_different(other)
        denom = other.x - @x
        (other.y - @y) * Number.mod_inverse(denom, @curve.p)
      end

      def calculate_slope(other)
        if equal?(other)
          slope_when_equal
        else
          slope_when_different(other)
        end
      end
    end

    # Eliptic Curve
    class Curve
      attr_accessor :a, :b, :p
      def initialize(p, arg)
        @a, @b = arg
        @p = p
      end

      def point(x, y)
        Point.new(self, x, y)
      end

      def zero
        Point.new(self, Float::INFINITY, Float::INFINITY)
      end
    end
  end
end
