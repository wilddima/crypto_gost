module CryptoGost
  module HashGost12
    # Hash function
    #
    # @author WildDima
    class HashFunction
      def initialize(message)
        @message = message
        @n = BinaryVector.new Array.new(512, 0)
        @sum = BinaryVector.new Array.new(512, 0)
      end

      def hashing!(digest_length: 512)
        @digest_length = digest_length
        @hash_vector = create_hash_vector(digest_length)

        while @message.size > HASH_LENGTH
          message = Message.from_bin BinaryVector.new(@message.vector[-HASH_LENGTH..-1])
          message_cut!(sum: @sum, n: @n, message: message, hash_vector: @hash_vector)
          @message = Message.from_bin BinaryVector.new(@message.vector[0...-HASH_LENGTH])
        end

        core_hashing!(sum: @sum, n: @n, message: @message, hash_vector: @hash_vector)

        @hash_vector = compress(message: @n, hash_vector: @hash_vector)

        @hash_vector = compress(message: @sum, hash_vector: @hash_vector)

        self
      end

      # TODO: MORE DRY
      def hash_vector
        case @digest_length
        when 512
          @hash_vector
        when 256
          BinaryVector.new @hash_vector[0..255]
        else
          raise ArgumentError,
                "digest length must be equal to 256 or 512, not #{digest_length}"
        end
      end

      private

      def create_hash_vector(digest_length)
        case digest_length
        when 512
          BinaryVector.new(Array.new(512, 0))
        when 256
          Array.new(64, '00000001').join.chars.map(&:to_i)
        else
          raise ArgumentError,
                "digest length must be equal to 256 or 512, not #{digest_length}"
        end
      end

      def message_cut!(sum:, n:, message:, hash_vector:)
        @hash_vector = compress(n: n, message: message.vector, hash_vector: hash_vector)
        @n = addition_in_ring(n.to_dec, message.vector.size)
        @sum = addition_in_ring(sum.to_dec, message.vector.to_dec)
      end

      def core_hashing!(sum:, n:, message:, hash_vector:)
        @hash_vector = compress(n: n.addition_to(size: 512),
                                message: message.addition_to(size: 512),
                                hash_vector: hash_vector)
        @n = addition_in_ring(n.to_dec, message.size)
        @sum = addition_in_ring(sum.to_dec, message.addition_to(size: 512).to_dec)
      end

      def addition_in_ring(first, second)
        HashGost12.addition_in_ring_to_binary(first, second)
      end

      def compress(message:, hash_vector:, n: nil)
        n ||= BinaryVector.new(Array.new(512, 0))
        Compression.new(n, message, hash_vector).start
      end
    end
  end
end
