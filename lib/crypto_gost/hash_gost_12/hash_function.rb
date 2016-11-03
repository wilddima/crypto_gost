module CryptoGost
  module HashGost12
    # Hash function
    #
    # @author Topornin Dmitry
    class HashFunction
      def initialize(message)
        @message = message
        @n = 0
        @sum = 0
      end

      def hashing(digest_length: 512)
        @digest_length = digest_length
        @hash_vector = hash_vector digest_length
        @message, @n, @sum, @hash_vector = message_cut(@message, @n,
                                                       @sum, @hash_vector)
      end

      private

      def hash_vector(digest_length)
        case digest_length
        when 512
          '\x00' * 64
        when 256
          '\x01' * 64
        else
          raise ArgumentError, 'digest length must be equal to 256 or 512'
        end
      end

      def message_cut(message, n, sum, hash_vector)
        # if message length, bigger than hash lengt
        while message.length >= HASH_LENGTH / 8
          message_last64 = message[-64..-1]
          hash_vector = compression_func(n, hash_vector, message_last64)
          # N = (N + 512) 2**512
          n = ((n + HASH_LENGTH) % 2)**HASH_LENGTH
          # sum = sum + m 2**512
          sum = ((sum + message_last64.unpack('N').first) % 2)**HASH_LENGTH
          # remove hashed part of message
          message = message[0..-64]
        end
        [message, n, sum, hash_vector]
      end

      def compression_func(n, hash_vector, message)
        p "#{n}, #{hash_vector}, #{message}"
        hash_vector
      end
    end
  end
end
