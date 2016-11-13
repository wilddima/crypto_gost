require_relative 'crypto_gost/version'
require_relative 'crypto_gost/message'
require_relative 'crypto_gost/hash_gost_12'
require_relative 'crypto_gost/hash_gost_12/hash_function'
require_relative 'crypto_gost/hash_gost_12/compression'
require_relative 'crypto_gost/binary_vector'

# Gost cryptography
module CryptoGost
  # Your code goes here...
  def hex_to_bin(hex)
    hex.chars.map do |x|
      bin = x.to_i(16).to_s(2)
      '0'*(4 - bin.length) + bin
    end.join
  end

  def bin_to_hex(bin)
    bin.to_i(2).to_s(16)
  end
end
