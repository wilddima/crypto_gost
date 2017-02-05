require 'openssl'

module CryptoGost
  # DigitalSignature
  #
  # @author WildDima
  class Signature
    attr_reader :r, :s

    class << self
      def decode(sign)
        asn1 = OpenSSL::ASN1.decode(sign)
        r = asn1.value[0].value.to_i
        s = asn1.value[1].value.to_i
        new(r, s)
      end
    end

    def initialize(r:, s:)
      @r = r
      @s = s
    end
      
    def encode
      asn1 = OpenSSL::ASN1::Sequence.new [
        OpenSSL::ASN1::Integer.new(r),
        OpenSSL::ASN1::Integer.new(s),
      ]
      asn1.to_der
    end
  end
end
