module CryptoGost
  # DigitalSignatureGost12
  #
  # @author WildDima
  module DigitalSignatureGost12
    # rubocop:disable Style/NumericLiterals
    require_relative './digital_signature_gost_12/digital_signature'
    require_relative './digital_signature_gost_12/elliptic_curve_point'
    # p - elliptic curve module
    # a - coefficients of elliptic curve
    # m - elliptic curve points order
    # gx, gy - point(P in gost)
    # n - G-point order(q in gost)
    # h - ?

    DEFAULT_GOST_OPTS = {
      p: 57896044618658097711785492504343953926634992332820282019728792003956564821041,
      a: 7,
      b: 43308876546767276905765904595650931995942111794451039583252968842033849580414,
      gx: 2,
      gy: 4018974056539037503335449422937059775635739389905545080690979365213431566280,
      n: 57896044618658097711785492504343953927082934583725450622380973592137631069619,
      m: 57896044618658097711785492504343953927082934583725450622380973592137631069619,
      h: 1
    }.freeze
    # rubocop:enable Style/NumericLiterals
  end
end
