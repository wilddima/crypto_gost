# Gost cryptography
#
# @author WildDima
module CryptoGost
  require_relative './crypto_gost/version'
  require_relative './crypto_gost/message'
  require_relative './crypto_gost/hash_gost_12'
  require_relative './crypto_gost/digital_signature_gost_12'
  require_relative './crypto_gost/binary_vector'
  require_relative './crypto_gost/modular_arithmetic'
  require 'byebug'

  class << self
    def padding(binary_vector, size: 512)
      return if binary_vector.size >= size
      (BinaryVector.new([1]) + binary_vector).addition_to(size: 512)
    end
  end
end
