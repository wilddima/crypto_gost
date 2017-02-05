require 'stribog'
require 'securerandom'
require 'ruby-prof'

module CryptoGost
  # DigitalSignature
  #
  # @author WildDima
  class Create
    attr_reader :group, :public_key, :signature_adapter, :create_hash

    def initialize(message, group, signature_adapter: Signature,
                                   create_hash: Stribog::CreateHash)
      @signature_adapter = signature_adapter
      @create_hash = create_hash
      @message = message
      @group = group
    end

    def call(private_key)
      # result = RubyProf.profile do
      #   @private_key = private_key
      #   loop do
      #     rand_val = SecureRandom.random_number(1..group.order)
      #     r = r_func(rand_val)
      #     s = s_func(rand_val, private_key)
      #     break new_signature(r: r, s: s) if !r.zero? || !s.zero?
      #   end
      # end
      # printer = RubyProf::GraphHtmlPrinter.new(result)
      # f = File.new('prof.html', 'w')
      # printer.print(f, min_percent: 2)

      @private_key = private_key
      loop do
        rand_val = SecureRandom.random_number(1..group.order)
        r = r_func(rand_val)
        s = s_func(rand_val, private_key)
        break new_signature(r: r, s: s) if !r.zero? || !s.zero?
      end
    end

    private

    def hash_message(message, size: 256)
      new_hash(message, size: size)
    end

    def r_func(rand_val)
      (group.generator * rand_val).x % group.order
    end

    def s_func(rand_val, private_key)
      (r_func(rand_val) * private_key + rand_val * hash_mod_ecn.to_dec) %
        group.order
    end

    def hash_mod_ecn
      hashed = hash_message(@message, size: 256)
      hashed.zero? ? 1 : hashed
    end

    def new_signature(keys)
      signature_adapter.new(r: keys[:r], s: keys[:s])
    end

    def new_hash(message, size: 256)
      create_hash.new(message).(size)
    end
  end
end
