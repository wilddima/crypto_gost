module CryptoGost
  module DigitalSignatureGost12
    # EllipticCurvePoint
    #
    # author WildDima
    class EllipticCurvePoint
      attr_accessor :x, :y, :opts

      def initialize(opts, coords)
        @opts = opts
        @x, @y = coords
      end

      def base_point
        [@opts[:gx], @opts[:gy]]
      end

      def coords
        [x, y]
      end

      # rubocop:disable Metrics/AbcSize
      def +(other)
        unless other.is_a? EllipticCurvePoint
          raise ArgumentError, "Invalid other: #{other.inspect}"
        end

        new_x = add_ec_module(other.x - @x)
        new_y = add_ec_module(other.y - @y)

        s = add_ec_module(
          (new_y * ModularArithmetic.invert(new_x, @opts[:p])) % @opts[:p]
        )

        new_x = add_ec_module((s**2 - @x - other.x) % @opts[:p])
        new_y = add_ec_module((s * (@x - new_x) - @y) % @opts[:p])

        self.class.new @opts, [new_x, new_y]
      end

      def double
        new_x = add_ec_module(2 * y)
        new_y = add_ec_module(3 * x**2 + @opts[:a])

        s = (new_y * ModularArithmetic.invert(new_x, @opts[:p])) % @opts[:p]

        new_x = add_ec_module(s**2 - 2 * @x) % @opts[:p]
        new_y = add_ec_module(s * (@x - new_x) - @y) % @opts[:p]

        self.class.new @opts, [new_x, new_y]
      end
      # rubocop:enable Metrics/AbcSize

      def *(other)
        return unless other.is_a? Numeric
        if other == 1
          self
        elsif (other % 2).odd?
          self + (self * (other - 1))
        else
          double * (other / 2)
        end
      end

      def add_ec_module(coord)
        coord < 0 ? coord + @opts[:p] : coord
      end
    end
  end
end
