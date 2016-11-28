# Source: http://www.secg.org/collateral/sec2_final.pdf

module CryptoGost
  module DigitalSignatureGost12
    class Group
      Secp256k1 = new(
        name: 'secp256k1',
        p: 0xFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFE_FFFFFC2F,
        a: 0,
        b: 7,
        gx: 0x79BE667E_F9DCBBAC_55A06295_CE870B07_029BFCDB_2DCE28D9_59F2815B_16F81798,
        gy: 0x483ADA77_26A3C465_5DA4FBFC_0E1108A8_FD17B448_A6855419_9C47D08F_FB10D4B8,
        n: 0xFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFE_BAAEDCE6_AF48A03B_BFD25E8C_D0364141,
        h: 1,
      )
    end
  end
end
