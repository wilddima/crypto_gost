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

    GROUP = {
      nistp192: { p: 62771017353866807638357894232076664160839087_00390324961279,
                  a: -3,
                  b: 0x64210519_e59c80e7_0fa7e9ab_72243049_feb8deec_c146b9b1,
                  gx: 0x188da80e_b03090f6_7cbf20eb_43a18800_f4ff0afd_82ff1012,
                  gy: 0x07192b95_ffc8da78_631011ed_6b24cdd5_73f977a1_1e794811,
                  n: 62771017353866807638357894231760590137671947_73182842284081,
                  h: nil },
      nistp224: { p: 26959946667150639794667015087019630673557916_260026308143510066298881,
                  a: -3,
                  b: 0xb4050a85_0c04b3ab_f5413256_5044b0b7_d7bfd8ba_270b3943_2355ffb4,
                  g: [0xb70e0cbd_6bb4bf7f_321390b9_4a03c1d3_56c21122_343280d6_115c1d21,
                      0xbd376388_b5f723fb_4c22dfe6_cd4375a0_5a074764_44d58199_85007e34],
                  n: 26959946667150639794667015087019625940457807_714424391721682722368061,
                  h: nil }
    }.freeze
    # rubocop:enable Style/NumericLiterals
  end
end
