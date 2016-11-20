require 'spec_helper'

# TODO: REFACTOR
describe CryptoGost::DigitalSignatureGost12::DigitalSignature do
  context '256 bit hash, with 504 bit message' do
    message = CryptoGost::Message.from_hex '323130393837363534333231303938373635343332313039383736353433323130393837363534333231303938373635343332313039383736353433323130'
    ecp = CryptoGost::DigitalSignatureGost12::EllipticCurvePoint.new(CryptoGost::DigitalSignatureGost12::DEFAULT_OPTS, [2, 4018974056539037503335449422937059775635739389905545080690979365213431566280])
    q = CryptoGost::DigitalSignatureGost12::DigitalSignature.new(message, ecp)
    q.create(CryptoGost::BinaryVector.from_byte(55441196065363246126355624130324183196576709222340016572108097750006097525544))
    it 'should has correct hash' do
      expect(q).to eq('557be5e584fd52a449b16b0251d05d27f94ab76cbaa6da890b59d8ef1e159d')
    end
  end
end