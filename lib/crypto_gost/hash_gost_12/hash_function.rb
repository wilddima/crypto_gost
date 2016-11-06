module CryptoGost
  module HashGost12
    # Hash function
    #
    # @author WildDima
    class HashFunction
      using CryptoGost::Refinements

      attr_accessor :test_var1, :test_var2
      def initialize(message)
        @message = message
        @n = Vector.elements Array.new(512, 0)
        @sum = Vector.elements Array.new(512, 0)
      end

      def hashing(digest_length: 512)
        @digest_length = digest_length
        @hash_vector = hash_vector digest_length
        @message, @n, @sum, @hash_vector = message_cut(@message, @n,
                                                       @sum, @hash_vector)
      end

      private

      # rubocop:disable Metrics/LineLength
      def hash_vector(digest_length)
        case digest_length
        when 512
          Vector.elements Array.new(512, 0)
        when 256
          Vector.elements Array.new(512, 1)
        else
          raise ArgumentError,
                "digest length must be equal to 256 or 512, not #{digest_length}"
        end
      end
      # rubocop:enable Metrics/LineLength

      def message_cut(message, n, sum, hash_vector)
        # if message length, bigger than hash lengt
        while message.length >= HASH_LENGTH / 8
          message_last512 = message[-512..-1]
          hash_vector = compression_func(n, hash_vector, message_last512)
          # N = (N + 512) 2**512
          n = ((n + HASH_LENGTH) % 2)**HASH_LENGTH
          # sum = sum + m 2**512
          sum = ((sum + message_last512.unpack('N*').first) % 2)**HASH_LENGTH
          # remove hashed part of message
          message = message[0..-64]
        end
        [message, n, sum, hash_vector]
      end

      def compression_func(n, hash_vector, message)
        [n, hash_vector, message]
      end

      def func_x(n, hash_vector)
        n.xor hash_vector
      end
    end
  end
end
