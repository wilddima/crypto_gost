require 'spec_helper'
require 'securerandom'

# TODO: REFACTOR
describe CryptoGost::DigitalSignatureGost12::DigitalSignature do
  context 'elliptic curve signature' do
    NAMES = %w(
      Nistp192
      Nistp224
      Nistp256
      Nistp384
      Nistp521
      Secp112r1
      Secp112r2
      Secp128r1
      Secp128r2
      Secp160k1
      Secp160r1
      Secp160r2
      Secp192k1
      Secp192r1
      Secp224k1
      Secp224r1
      Secp256k1
      Secp256r1
      Secp384r1
      Secp521r1
      ).freeze

    NAMES.each do |name|
      context name do
        let(:group) { Object.const_get("CryptoGost::DigitalSignatureGost12::Group::#{name}") }
        let(:private_key) { group.generate_private_key }
        let(:public_key) { group.generate_public_key private_key }
        let(:message) { CryptoGost::Message.from_string(Faker::Lorem.sentence(3)) }
        let(:sign) { CryptoGost::DigitalSignatureGost12::DigitalSignature.new(message, group) }
        let(:signature) { sign.create(private_key) }

        it 'should has valid sign' do
          expect(sign.valid?(public_key, signature)).to be_truthy
        end

        context 'change message' do
          let(:another_message) { CryptoGost::Message.from_string(Faker::Lorem.sentence(2)) }
          let(:another_sign) { CryptoGost::DigitalSignatureGost12::DigitalSignature.new(another_message, group) }
          let(:another_signature) { sign.create(private_key) }

          it 'should has invalid sign' do
            expect(another_sign.valid?(public_key, another_signature)).to be_falsy
          end
        end
      end
    end
  end
end
