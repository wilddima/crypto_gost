require 'stribog'

module CryptoGost
  # DigitalSignature
  #
  # @author WildDima
  class Verify
    attr_reader :group, :public_key, :create_hash, :message

    def initialize(message, group, create_hash = Stribog::CreateHash)
      @message = message
      @group = group
      @create_hash = create_hash
    end

    def call(public_key, sign)
      @public_key = public_key
      @sign = sign
      @hashed_message = hash_message(@message, size: 256)
      r = sign.r
      s = sign.s
      return false if invalid_vector?(r) || invalid_vector?(s)
      (c_param(r, s).x % group.order) == r
    end

    private

    def hash_message(message, size: 256)
      create_hash.new(message).(size)
    end

    def hash_mod_ecn
      hashed = hash_message(message, size: 256)
      hashed.zero? ? 1 : hashed
    end

    def mod_inv(opt, mod)
      ModularArithmetic.invert(opt, mod)
    end

    def valid_vector?(vector)
      (1...group.order).cover? vector
    end

    def invalid_vector?(vector)
      !valid_vector?(vector)
    end

    def z_param(param)
      param * mod_inv(hash_mod_ecn.to_dec, group.order) %
        group.order
    end

    def c_param(r, s)
      group.generator * z_param(s) + public_key * z_param(-r)
    end
  end
end
