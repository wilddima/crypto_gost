require 'spec_helper'
require 'securerandom'

# TODO: REFACTOR
describe CryptoGost do
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
        let(:group) { Object.const_get("CryptoGost::Group::#{name}") }
        let(:private_key) { group.generate_private_key }
        let(:public_key) { group.generate_public_key private_key }
        let(:message) { Faker::Lorem.sentence(3) }
        let(:sign) { CryptoGost::Create.new(message, group) }
        let(:signature) { sign.(private_key) }
        let(:verify) { CryptoGost::Verify.new(message, group) }

        it 'should has valid sign' do
          expect(verify.(public_key, signature)).to be_truthy
        end

        context 'change message' do
          let(:another_message) { Faker::Lorem.sentence(2) }
          let(:verify) { CryptoGost::Verify.new(another_message, group) }

          it 'should has invalid sign' do
            expect(verify.(public_key, signature)).to be_falsy
          end
        end
      end
    end
  end
end
