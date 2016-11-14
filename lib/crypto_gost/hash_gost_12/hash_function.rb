module CryptoGost
  module HashGost12
    # Hash function
    #
    # @author WildDima
    class HashFunction
      using CryptoGost::Refinements

      attr_reader :hash_vector

      def initialize(message)
        @message = message
        @n = BinaryVector.new Array.new(512, 0)
        @sum = BinaryVector.new Array.new(512, 0)
      end

      def hashing(digest_length: 512)
        @digest_length = digest_length
        @hash_vector = set_hash_vector digest_length
        @sum, @n, @message, @hash_vector = MessageCut.new(@sum, @n, @message, @hash_vector).start
        @hash_vector = Compression.new(@n.addition_to(size: 512), @message.addition_to(size: 512), @hash_vector).start
        @n_bv = CryptoGost::HashGost12::addition_in_ring_to_binary(@n.to_dec, 
                                                                   @message.size, 
                                                                   2**HASH_LENGTH,
                                                                   size: 512)

        @sum_bv = CryptoGost::HashGost12::addition_in_ring_to_binary(@sum.to_dec, 
                                                                     @message.addition_to(size: 512).to_dec, 
                                                                     2**HASH_LENGTH,
                                                                     size: 512)

        @hash_vector = Compression.new(BinaryVector.new(Array.new(512, 0)),
                                       @n_bv,
                                       @hash_vector).start

        @hash_vector = Compression.new(BinaryVector.new(Array.new(512, 0)),
                                       @sum_bv,
                                       @hash_vector).start
        
      end

      private

      # rubocop:disable Metrics/LineLength
      def set_hash_vector(digest_length)
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
      # rubocop:enable Metrics/LineLength
    end
  end
end
