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
        loop do
          rand_val = rand(1..@elliptic_curve.opts[:n])
          r = r_func(rand_val)
          s = s_func(rand_val, private_key)
          if !r.zero? || !s.zero?
            break { r: BinaryVector.from_byte(r), s: BinaryVector.from_byte(s) }
          end
        end
      end

      def valid?(publick_key, sign)
        @publick_key = publick_key
        @sign = sign
        @hashed_message = hash_message(@message, size: 256)
        r = sign[:r]
        s = sign[:s]
        return false if invalid_vector?(r) || invalid_vector?(s)
        (c_param(publick_key, r.to_dec, s.to_dec).x % @elliptic_curve.opts[:n]) == r.to_dec
      end

      private

      def hash_message(message, size: 256)
        CryptoGost::HashGost12::HashFunction.new(message).hashing!(digest_length: size)
      end

      def r_func(rand_val)
        (EllipticCurvePoint.new(@elliptic_curve.opts, @elliptic_curve.base_point) * rand_val).x %
          @elliptic_curve.opts[:n]
      end

      def s_func(rand_val, private_key)
        (r_func(rand_val) * private_key.to_dec + rand_val * hash_mod_ecn.to_dec) %
          @elliptic_curve.opts[:n]
      end

      def hash_mod_ecn
        hashed = hash_message(@message, size: 256).hash_vector
        hashed.zero? ? 1 : hashed
      end

      def mod_inv(opt, mod)
        ModularArithmetic.invert(opt, mod)
      end

      def valid_vector?(vector)
        (1...@elliptic_curve.opts[:n]).cover? vector.to_dec
      end

      def invalid_vector?(vector)
        !valid_vector?(vector)
      end

      def z_param(param)
        param * mod_inv(hash_mod_ecn.to_dec, @elliptic_curve.opts[:n]) %
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
