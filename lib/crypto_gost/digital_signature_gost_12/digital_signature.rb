module CryptoGost
  module DigitalSignatureGost12
    # DigitalSignature
    #
    # @author WildDima
    class DigitalSignature
      def initialize(message, elliptic_curve)
        @message = message
        @elliptic_curve = elliptic_curve
      end

      def create(private_key)
        @private_key = private_key
        vectors = loop do
          rand_val = rand(1..@elliptic_curve.opts[:n])
          r = r_func(rand_val)
          s = s_func(rand_val, private_key)
          puts r
          puts s
          break { r: r, s: s } if !r.zero? || !s.zero?
        end
        vectors.inject(0) { |acc, (_ind, val)| acc + val }
      end

      def valid?(publick_key, sign)
        @publick_key = publick_key
        @sign = sign
        @hashed_message = hash_message(@message)
        r = sign[0..@elliptic_curve.opts[:n]]
        s = sign[@elliptic_curve.opts[:n]..-1]
        return false if invalid_vector?(r) || invalid_vector?(s)
        (c_param.x(publick_key, r, s) % @elliptic_curve.opts[:n]) == r
      end

      private

      def hash_message(message, size)
        CryptoGost::HashGost12::HashFunction.new(message).hashing(digest_length: size)
      end

      def r_func(rand_val)
        (EllipticCurvePoint.new(@elliptic_curve.opts, @elliptic_curve.base_point) * rand_val).x % @elliptic_curve.opts[:n]
      end

      def s_func(rand_val, private_key)
        (r_func(rand_val) * private_key.to_dec + rand_val * hash_mod_ecn.to_dec) % @elliptic_curve.opts[:n]
      end

      def hash_mod_ecn
        hashed = hash_message(@message, 256).to_dec
        hashed.zero? ? 1 : hashed
        BinaryVector.from_byte(20798893674476452017134061561508270130637142515379653289952617252661468872421)
      end

      def mod_inv(opt, mod)
        ModularArithmetic.invert(opt, mod)
      end

      def valid_vector?(vector)
        vector <= 0 || vector >= @elliptic_curve.opts[:n]
      end

      def invalid_vector?(vector)
        !valid_vector?(vector)
      end

      def z_param(param)
        param * mod_inv(hash_mod_ecn, @elliptic_curve.opts[:n]) %
          @elliptic_curve.opts[:n]
      end

      def c_param(publick_key, r, s)
        EllipticCurvePoint.new(@elliptic_curve.opts,
                               @elliptic_curve.base_point) * z_param(s) +
          EllipticCurvePoint.new(@elliptic_curve.opts,
                                 publick_key) * z_param(-r)
      end
    end
  end
end
