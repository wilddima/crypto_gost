module CryptoGost
  # Group
  #
  # @author WildDima
  class Group
    attr_reader :opts, :generator, :a, :b, :gx, :gy, :order, :p

    def initialize(opts)
      @opts = opts
      @name = opts.fetch(:name)
      @p = opts[:p]
      @a = opts[:a]
      @b = opts[:b]
      @gx = opts[:gx]
      @gy = opts[:gy]
      @order = opts[:n]
      @cofactor = opts[:h]
      @generator = CryptoGost::Point.new self, [gx, gy]
    end

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
      require_relative "./group/#{name.downcase}"
    end

    def generate_public_key(private_key)
      generator * private_key
    end

    def generate_private_key
      1 + SecureRandom.random_number(order - 1)
    end
  end
end
