module CryptoGost
  module HashGost12
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
          rand_val = rand(1..@elliptic_curve.n)
          r = r_func(rand_val)
          s = s_func(rand_val, private_key)
          break { r: r, s: s } if !r.zero? || !s.zero?
        end
      end

      def check(publick_key, sign)
        @publick_key = publick_key
        @sign = sign
        @hashed_message = hash_message(@message)
      end

      private

      def hash_message(message)
        ::HashGost12::HashFunction(message).hashing(digest_length: 256)
                    .hash_vector
      end

      def r_func(rand_val)
        (@elliptic_curve.base_point * rand_val).x % @elliptic_curve.n
      end

      def s_func(rand_val, private_key)
        (r_func * private_key + rand_val * hash_mod_ecn) % @elliptic_curve.n
      end

      def hash_mod_ecn
        hashed = hash_message(@message, size: 256).to_dec
        hashed.zero? ? 1 : hashed
      end
    end
  end
end
