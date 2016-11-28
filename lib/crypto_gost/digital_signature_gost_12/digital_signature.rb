module CryptoGost
  module DigitalSignatureGost12
    # DigitalSignature
    #
    # @author WildDima
    class DigitalSignature
      attr_reader :group, :public_key
      def initialize(message, group)
        @message = message
        @group = group
      end

      def create(private_key)
        @private_key = private_key
        loop do
          rand_val = rand(1..group.order)
          r = r_func(rand_val)
          s = s_func(rand_val, private_key)
          break Signature.new(r: r, s: s) if !r.zero? || !s.zero?
        end
      end

      def valid?(public_key, sign)
        @public_key = public_key
        @sign = sign
        @hashed_message = hash_message(@message, size: 256)
        r = sign.r
        s = sign.s
        return false if invalid_vector?(r) || invalid_vector?(s)
        (c_param(r, s).x % group.order) == r
      end

      private

      def hash_message(message, size: 256)
        CryptoGost::HashGost12::HashFunction.new(message).hashing!(digest_length: size)
      end

      def r_func(rand_val)
        (group.generator * rand_val).x % group.order
      end

      def s_func(rand_val, private_key)
        (r_func(rand_val) * private_key + rand_val * hash_mod_ecn.to_dec) %
          group.order
      end

      def hash_mod_ecn
        hashed = hash_message(@message, size: 256).hash_vector
        hashed.zero? ? 1 : hashed
      end

      def mod_inv(opt, mod)
        ModularArithmetic.invert(opt, mod)
      end

      def valid_vector?(vector)
        (1...group.order).cover? vector
      end

      def invalid_vector?(vector)
        !valid_vector?(vector)
      end

      def z_param(param)
        param * mod_inv(hash_mod_ecn.to_dec, group.order) %
          group.order
      end

      def c_param(r, s)
        group.generator * z_param(s) + public_key * z_param(-r)
      end
    end
  end
end
