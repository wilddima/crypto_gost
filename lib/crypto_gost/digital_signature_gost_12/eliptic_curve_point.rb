module CryptoGost
  module DigitalSignatureGost12
    # EllipticCurvePoint
    #
    # author WildDima
    class EllipticCurvePoint
      attr_accessor :x, :y
      attr_reader :n

      def initialize(opts)
        @p = opts[:p]
        @a = opts[:a]
        @b = opts[:b]
        @gx = opts[:gx]
        @gy = opts[:gy]
        @n = opts[:n]
        @h = opts[:h]
        @x = opts[:x]
        @y = opts[:y]
      end

      def base_point
        { x: @gx, y: @gy }
      end

      # rubocop:disable Metrics/AbcSize
      def +(other)
        unless other.is_a? EllipticCurvePoint
          raise ArgumentError, "Invalid other: #{other.inspect}"
        end

        new_point = dup(x: other.x - @x,
                        y: other.y - @y)

        new_point.add_module!

        s = (new_point.y * ModularArithmetic.invert(new_point.x, @p)) % @p

        new_point.x = (s**2 - 2 * @x) % @p
        new_point.y = (s * (@x - other.x) - @y) % @p

        add_module! new_point.x, new_point.y
      end

      def double
        new_point = dup(x: 3 * x**2 + @a,
                        y: 2 * y)

        new_point.add_module!

        s = (new_point.y * ModularArithmetic.invert(new_point.x, @p)) % @p

        new_point.x = (s**2 - 2 * @x) % @p
        new_point.y = (s * (@x - new_point.x) - @y) % @p

        new_point.add_module!
      end

      def *(other)
        return unless other.is_a? Numeric
        if other == 1
          self
        elsif (other % 2).odd?
          self + (self * (other - 1))
        else
          other / 2 * double
        end
      end
      # rubocop:enable Metrics/AbcSize

      private

      def add_module!
        @x += @p if x < 0
        @y += @p if y < 0
        self
      end
    end
  end
end
