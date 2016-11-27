require 'spec_helper'

# TODO: REFACTOR
describe CryptoGost::DigitalSignatureGost12::DigitalSignature do
  context '256 bit hash, with 504 bit message' do
    public_key = [57520216126176808443631405023338071176630104906313632182896741342206604859403, 17614944419213781543809391949654080031942662045363639260709847859438286763994]
    message = CryptoGost::Message.from_bin(CryptoGost::BinaryVector.new '11010000100100011101000010110000110100001011100111010001100000101101000110001011'.chars.map(&:to_i))
    ecp = CryptoGost::DigitalSignatureGost12::EllipticCurvePoint.new(CryptoGost::DigitalSignatureGost12::DEFAULT_GOST_OPTS, [2, 4018974056539037503335449422937059775635739389905545080690979365213431566280])
    q = CryptoGost::DigitalSignatureGost12::DigitalSignature.new(message, ecp)
    s = q.create(CryptoGost::BinaryVector.from_byte(55441196065363246126355624130324183196576709222340016572108097750006097525544))
    it 'should has correct hash' do
      expect(q.valid?(public_key, s)).to be_truthy
    end
  end
end