module CryptoGost
  module HashGost12
    class Compression
      def initialize(n, message, hash_vector)
        @n, @hash_vector, @message = n, hash_vector, message
      end

      def start
        vector = lpsx_func @n, @hash_vector
        vector = func_e vector, @message
        vector = vector ^ @hash_vector
        vector ^ @message
      end

      private

      def lpsx_func(first_vector, second_vector)
        linear_transformation(
          permutation_t(
            replacement_pi(
              first_vector ^ second_vector
            )
          )
        )
      end

      def replacement_pi(vector)
        BinaryVector.from_byte_array vector.to_byte_array
                                           .map { |byte| PI[byte] }
      end

      def permutation_t(vector)
        BinaryVector.from_byte_array(vector.to_byte_array
                                           .each.with_index.inject([]) do |byte_array, (byte, index)|
                                              byte_array[T[index]] = byte
                                              byte_array
                                            end)
      end

      def linear_transformation(vector)
        BinaryVector.from_byte_array(
          vector.each_slice(64).map do |byte8|
            small_linear_transformation(BinaryVector.new(byte8)).to_dec
          end,
          size: 64
        )
      end

      def small_linear_transformation(vector)
        BinaryVector.from_byte(
          not_zeros_indexes(vector).inject(0) { |sum, index| sum ^= MATRIX_A[index] }
        ).addition_to(size: 64)
      end


      def func_e(first_vector, second_vector)
        vectors = CONSTANTS_C.inject({v1: first_vector.dup,
                                      v2: second_vector.dup}) do |vectors, const|
                                        vectors[:v2] = lpsx_func(vectors[:v1], vectors[:v2])
                                        vectors[:v1] = lpsx_func(vectors[:v1],
                                                                 BinaryVector.from_byte(const.to_i(16),
                                                                                        size: 512))
                                        vectors
                  end
        vectors[:v1] ^ vectors[:v2]
      end

      def not_zeros_indexes(vector)
        vector.map.with_index do |bit, index|
          next if bit.zero?
          index
        end.compact
      end
    end
  end
end
