module CryptoGost
  module HashGost12
    class MessageCut
      attr_reader :sum, :n, :message, :hash_vector
      def initialize(sum, n, message, hash_vector)
        @sum, @n, @message, @hash_vector = sum, n, message, hash_vector
      end

      def start
        while @message.size > HASH_LENGTH
          message = Message.from_bin BinaryVector.new(@message.vector[-HASH_LENGTH..-1])
          @hash_vector = Compression.new(@n,
                                         message.vector,
                                         @hash_vector).start
          @n = CryptoGost::HashGost12::addition_in_ring_to_binary(@n.to_dec,
                                                                  message.size,
                                                                  2**HASH_LENGTH)
          @sum = CryptoGost::HashGost12::addition_in_ring_to_binary(@sum.to_dec,
                                                                    message.vector.to_dec,
                                                                    2**HASH_LENGTH)
          @message = Message.from_bin BinaryVector.new(@message.vector[0..-HASH_LENGTH])
        end
        [@sum, @n, @message, @hash_vector]
      end
    end
  end
end
