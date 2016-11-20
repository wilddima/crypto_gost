module CryptoGost
  # DigitalSignatureGost12
  #
  # @author WildDima
  module DigitalSignatureGost12
    # rubocop:disable Style/NumericLiterals
    # rubocop:disable Metrics/LineLength
    require_relative './digital_signature_gost_12/digital_signature'
    require_relative './digital_signature_gost_12/elliptic_curve_point'
    # p - elliptic curve module
    # a - coefficients of elliptic curve
    # m - elliptic curve points order
    # gx, gy - point(P in gost)
    # n - G-point order(q in gost)
    # h - ?
    DEFAULT_OPTS = {
      p: 115792089210356248762697446949407573530086143415290314195533631308867097853951,
      a: -3,
      b: 0x5ac635d8aa3a93e7b3ebbd55769886bc651d06b0cc53b0f63bce3c3e27d2604b,
      gx: 0x6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296,
      gy: 0x4fe342e2fe1a7f9b8ee7eb4a7c0f9e162bce33576b315ececbb6406837bf51f5,
      n: 115792089210356248762697446949407573529996955224135760342422259061068512044369,
      h: 1
    }.freeze

    DEFAULT_GOST_OPTS = {
      p:  578960446186580977117854925043439539266349923328202820197287920039565648210411,
      a: 7,
      b: 43308876546767276905765904595650931995942111794451039583252968842033849580414,
      gx: 2,
      gy: 4018974056539037503335449422937059775635739389905545080690979365213431566280,
      n: 57896044618658097711785492504343953927082934583725450622380973592137631069619,
      m: 57896044618658097711785492504343953927082934583725450622380973592137631069619,
      h: 1
    }.freeze
    # rubocop:enable Style/NumericLiterals
    # rubocop:enable Metrics/LineLength
  end
end
