module CryptoGost
  module HashGost12
    # Hash function
    #
    # @author WildDima
    class HashFunction
      attr_reader :digest_length, :hash_vector, :sum, :n, :message

      def initialize(message)
        @message = message
        @n = BinaryVector.new Array.new(512, 0)
        @sum = BinaryVector.new Array.new(512, 0)
      end

      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/AbcSize
      def hashing!(digest_length: 512)
        @digest_length = digest_length
        @sum, @n, @message, @hash_vector = MessageCut.new(sum,
                                                          n,
                                                          message,
                                                          create_hash_vector(digest_length)).start

        @hash_vector = Compression.new(n.addition_to(size: 512),
                                       message.addition_to(size: 512),
                                       @hash_vector).start

        @n_bv = HashGost12.addition_in_ring_to_binary(
          n.to_dec,
          message.size,
          2**HASH_LENGTH,
          size: 512
        )

        @sum_bv = HashGost12.addition_in_ring_to_binary(
          sum.to_dec,
          message.addition_to(size: 512).to_dec,
          2**HASH_LENGTH,
          size: 512
        )

        @hash_vector = Compression.new(BinaryVector.new(Array.new(512, 0)),
                                       @n_bv,
                                       @hash_vector).start

        @hash_vector = Compression.new(BinaryVector.new(Array.new(512, 0)),
                                       @sum_bv,
                                       @hash_vector).start
        self
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/MethodLength

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
          BinaryVector.new Array.new(512, 0)
        when 256
          Array.new(64, '00000001').join.chars.map(&:to_i)
        else
          raise ArgumentError,
                "digest length must be equal to 256 or 512, not #{digest_length}"
        end
      end
    end
  end
end
