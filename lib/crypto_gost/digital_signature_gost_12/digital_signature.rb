module CryptoGost
  module HashGost12
    # DigitalSignature
    #
    # @author WildDima
    class DigitalSignature
      def initialize(message)
        @message = message
      end

      def create(private_key)
        @private_key = private_key
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
    end
  end
end
