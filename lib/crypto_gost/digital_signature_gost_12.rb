module CryptoGost
  # DigitalSignatureGost12
  #
  # @author WildDima
  module DigitalSignatureGost12
    # rubocop:disable Style/NumericLiterals
    require_relative './digital_signature_gost_12/digital_signature'
    require_relative './digital_signature_gost_12/point'
    require_relative './digital_signature_gost_12/signature'
    require_relative './digital_signature_gost_12/modular_arithmetic'
    require_relative './digital_signature_gost_12/group'
    # p - elliptic curve module +
    # a, b - coefficients of elliptic curve
    # m - elliptic curve points order +
    # gx, gy - point(P in gost) +
    # n - G-point order(q in gost) +
    # h - ?
    # rubocop:enable Style/NumericLiterals
  end
end
