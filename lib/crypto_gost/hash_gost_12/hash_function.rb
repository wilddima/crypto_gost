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

      def compression_func(n, hash_vector, _message)
        linear_transformation(
          permutation_t(
            pi_replacement(
              vectors_xor(hash_vector, n)
            )
          )
        )
      end

      def vectors_xor(first_vector, second_vector)
        first_vector.xor second_vector
      end

      def replacement_pi(vector)
        byte_array = []
        vector.each_slice(8) { |byte| byte_array << PI[byte.join('').to_i(2)] }
        Vector.elements byte_array
      end

      def permutation_t(vector)
        byte_array = Array.new 64, 0
        vector.each_with_index do |byte, index|
          byte_array[T[index]] = byte
        end
        Vector.elements byte_array
      end

      def linear_transformation(vector)
        new_vector = []
        vector.each_slice(8) do |vector8|
          new_vector.merge small_linear_transformation(vector8.map do |b|
                                                         b.to_s(2)
                                                       end.join)
        end
        new_vector
      end

      def small_linear_transformation(vector)
        complete_vector = '0' * (64 - vector.length) + vector
        indexes = []
        result = 0
        complete_vector.chars.each_with_index do |bit, index|
          indexes << index unless bit.to_i.zero?
        end
        indexes.each do |index|
          result ^= MATRIX_A[index]
        end
        result.to_s(2).chars.map(&:to_i)
      end
    end
  end
end
