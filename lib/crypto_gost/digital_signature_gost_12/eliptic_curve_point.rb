module CryptoGost
  module HashGost12
    # EllipticCurvePoint
    #
    # author WildDima
    class EllipticCurvePoint
      attr_accessor :x, :y

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

      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/AbcSize
      def +(other)
        unless other.is_a? EllipticCurvePoint
          raise ArgumentError, "Invalid other: #{other.inspect}"
        end

        dx = other.x - x
        dy = other.y - y

        dx += @p if dx < 0
        dy += @p if dy < 0

        s = (dy * ModularArithmetic.invert(dx, @p)) % @p

        new_point = self.class.new(p: @p,
                                   a: @a,
                                   b: @b,
                                   gx: @gx,
                                   gy: @gy,
                                   n: @n,
                                   h: @h,
                                   x: (s**2 - 2 * x) % @p,
                                   y: (s * (x - other.x) - y) % @p)

        new_point.x += @p if new_point.x < 0
        new_point.y += @p if new_point.y < 0

        new_point
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/AbcSize
    end
  end
end
