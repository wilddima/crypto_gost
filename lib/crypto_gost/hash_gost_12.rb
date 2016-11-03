require 'matrix'

module CryptoGost
  module HashGost12
    # rubocop:disable Metrics/LineLength
    PI = ['T', '\x97', '\xaf', 'f', '&', '\xa0', '\xa8', '', '\xe6', '\x8e', '\xec', '\x1f', '\xc7', '\xd3',
          '\xd5', '\x85', 'l', '\xa7', 'H', '\xb1', 'q', '\xc8', '\\', '\x9a', '@', 'o', '\n', '$', '\x02',
          '\x06', '\x0', '\xc3', '\xe8', '\x98', '\xe7', '\x1c', 'p', '\xb8', '\x8c', 'G', '\xa4', '\x93',
          '^', '\xae', '\xa9', '\xb3', '!', 'j', '\x12', '\xe4', '\x8a', 'C', '\xc9', '\x8f', '\x0c', ']',
          '\x03', 'D', '\xda', '\xbc', '\xfe', '\xf0', '\x87', '\xc', '\xbd', '\x9f', '\xad', '\xb6', '\x0f',
          '\xb4', 'y', '\x17', '\x14', '\xa3', '\xc6', '\xb5', '\x90', '`', '"', 'u', '\xe', '6', '\xfd',
          '\x81', 'm', '\xcd', '\x83', 'O', '\x95', '\x84', 'e', '\xa2', '\x13', '\xf2', '\x0e', ':', '\x9',
          '\xf6', '\x89', '\xdc', '\xc1', '\x8d', 'L', 'V', 'F', '\xf9', 'P', '\xd9', '\t', '\xb0', '\xc2',
          '\x05', '\xe1', '(', '+', 'Q', '4', '5', '=', 'a', '\xd', '\xf', 'U', '\xb7', 'I', '\x94',
          '\x99', '%', '8', '\x07', 'E', '\'', '2', '{', '>', '\xf4', ' ', '\xca', '\xa', 's', '\xd8', ';',
          '\x96', '\xd7', '\xf1', '\xea', '_', 'J', '\xa5', '#', '\x80', '\xdf', '[', 'Y', '\xdd', 'r',
          '\x1e', 'Z', '-', '\xb9', '\x19', 'z', '\xf7', '\xc5', ')', '', '\xb2', '\xcc', '*', '|', '\xed',
          '\xc4', '\x1d', 'n', '\r', '\xe5', '\xac', '\x01', '7', '\x00', '\xfc', '\xf8', '/', '\xba', '\xaa',
          '\xe3', '\xef', '\x18', 'N', '\xff', 'k', '\x91', 'X', 'A', 'i', '\xf5', '\xe9', '\x82', '1', 'R',
          '\xee', '\xbf', '\xbe', '3', '<', '\xd2', 't', 'S', '\xd1', 'W', '\x8', 'h', '\x92', '\x04',
          '\xa6', 'g', '\xfa', '}', '\xb', '?', '\xd4', 'c', '\x86', 'd', '\x1', '\x08', '\x1a', '\xf3',
          '~', 'x', '\xce', '\x10', '\xd0', 'K', '\x88', '\xa1', '\xd6', '\x9d', 'w', '\x15', '.', 'M',
          '\xc0', '\xde', '9', '\x16', '\x9c', '\x7f', ',', '\xe2', 'v', '\xcf', '\x11', '0', '\xe0', '\x9e'].freeze

    T = [38, 23, 37, 55, 18, 7, 53, 1, 60, 21, 50, 46, 32, 15, 52, 10, 0, 27, 13,
         26, 2, 54, 25, 29, 43, 40, 41, 49, 33, 44, 63, 8, 6, 36, 12, 16, 3, 59,
         11, 24, 5, 57, 19, 58, 14, 35, 17, 20, 42, 62, 30, 45, 34, 51, 9, 56, 47,
         31, 4, 39, 28, 61, 48, 22].freeze

    MATRIX_A = Matrix[[0x8e20faa72ba0b470, 0x47107ddd9b505a38, 0xad08b0e0c3282d1c, 0xd8045870ef14980e,
                       0x6c022c38f90a4c07, 0x3601161cf205268d, 0x1b8e0b0e798c13c8, 0x83478b07b2468764,
                       0xa011d380818e8f40, 0x5086e740ce47c920, 0x2843fd2067adea10, 0x14aff010bdd87508,
                       0x0ad97808d06cb404, 0x05e23c0468365a02, 0x8c711e02341b2d01, 0x46b60f011a83988e,
                       0x90dab52a387ae76f, 0x486dd4151c3dfdb9, 0x24b86a840e90f0d2, 0x125c354207487869,
                       0x092e94218d243cba, 0x8a174a9ec8121e5d, 0x4585254f64090fa0, 0xaccc9ca9328a8950,
                       0x9d4df05d5f661451, 0xc0a878a0a1330aa6, 0x60543c50de970553, 0x302a1e286fc58ca7,
                       0x18150f14b9ec46dd, 0x0c84890ad27623e0, 0x0642ca05693b9f70, 0x0321658cba93c138,
                       0x86275df09ce8aaa8, 0x439da0784e745554, 0xafc0503c273aa42a, 0xd960281e9d1d5215,
                       0xe230140fc0802984, 0x71180a8960409a42, 0xb60c05ca30204d21, 0x5b068c651810a89e,
                       0x456c34887a3805b9, 0xac361a443d1c8cd2, 0x561b0d22900e4669, 0x2b838811480723ba,
                       0x9bcf4486248d9f5d, 0xc3e9224312c8c1a0, 0xeffa11af0964ee50, 0xf97d86d98a327728,
                       0xe4fa2054a80b329c, 0x727d102a548b194e, 0x39b008152acb8227, 0x9258048415eb419d,
                       0x492c024284fbaec0, 0xaa16012142f35760, 0x550b8e9e21f7a530, 0xa48b474f9ef5dc18,
                       0x70a6a56e2440598e, 0x3853dc371220a247, 0x1ca76e95091051ad, 0x0edd37c48a08a6d8,
                       0x07e095624504536c, 0x8d70c431ac02a736, 0xc83862965601dd1b, 0x641c314b2b8ee083]]

    CONSTANTS_C = ['\xb1\x08[\xda\x1e\xca\xda\xe9\xeb\xcb/\x81\xc0e|\x1f/jvC.E\xd0\x16qN\xb8\x8du\x85\xc4\xfcK|\xe0\x91\x92gi\x01\xa2B*\x08\xa4`\xd3\x15\x05vt6\xcctM#\xdd\x80eY\xf2\xa6E\x07',
                   'o\xa3\xb5\x8a\xa9\x9d/\x1aO\xe3\x9dF\x0fp\xb5\xd7\xf3\xfe\xear\n#+\x98a\xd5^\x0f\x16\xb5\x011\x9a\xb5\x17k\x12\xd6\x99X\\\xb5a\xc2\xdb\n\xa7\xcaU\xdd\xa2\x1b\xd7\xcb\xcdV\xe6y\x04p!\xb1\x9b\xb7',
                   '\xf5t\xdc\xac+\xce/\xc7\n9\xfc(j=\x845\x06\xf1^_R\x9c\x1f\x8b\xf2\xeau\x14\xb1){{\xd3\xe2\x0f\xe4\x905\x9e\xb1\xc1\xc9:7`b\xdb\t\xc2\xb6\xf4C\x86z\xdb1\x99\x1e\x96\xf5\n\xba\n\xb2',
                   '\xef\x1f\xdf\xb3\xe8\x15f\xd2\xf9H\xe1\xa0]q\xe4\xddH\x8e\x85~3\\<}\x9dr\x1c\xadh^5?\xa9\xd7,\x82\xed\x03\xd6u\xd8\xb7\x133\x93R\x03\xbe4S\xea\xa1\x93\xe87\xf1"\x0c\xbe\xbc\x84\xe3\xd1.',
                   'K\xeak\xac\xadGG\x99\x9a?A\x0cl\xa9#c\x7f\x15\x1c\x1f\x16\x86\x10J5\x9e5\xd7\x80\x0f\xff\xbd\xbf\xcd\x17G%:\xf5\xa3\xdf\xff\x00\xb7#\'\x1a\x16zV\xa2~\xa9\xeac\xf5`\x17X\xfd|l\xfeW',
                   '\xaeO\xae\xae\x1d:\xd3\xd9o\xa4\xc3;z09\xc0-f\xc4\xf9QB\xa4l\x18\x7f\x9a\xb4\x9a\xf0\x8e\xc6\xcf\xfa\xa6\xb7\x1c\x9a\xb7\xb4\n\xf2\x1ff\xc2\xbe\xc6\xb6\xbfq\xc5r6\x90O5\xfah@zFd}n',
                   '\xf4\xc7\x0e\x16\xee\xaa\xc5\xecQ\xac\x86\xfe\xbf$\tT9\x9e\xc6\xc7\xe6\xbf\x87\xc9\xd3G>3\x19z\x93\xc9\t\x92\xab\xc5-\x82,7\x06Gi\x83(J\x05\x045\x17EL\xa2<J\xf3\x88\x86VM:\x14\xd4\x93',
                   '\x9b\x1f[BM\x93\xc9\xa7\x03\xe7\xaa\x02\x0cnAAN\xb7\xf8q\x9c6\xde\x1e\x89\xb4D;M\xdb\xc4\x9a\xf4\x89+\xcb\x92\x9b\x06\x90i\xd1\x8d+\xd1\xa5\xc4/6\xac\xc25YQ\xa8\xd9\xa4\x7f\r\xd4\xbf\x02\xe7\x1e',
                   '7\x8fZT\x161"\x9b\x94L\x9a\xd8\xec\x16_\xde:}:\x1b%\x89B$<\xd9U\xb7\xe0\r\t\x84\x80\nD\x0b\xdb\xb2\xce\xb1{+\x8a\x9a\xa6\x07\x9cT\x0e8\xdc\x92\xcb\x1f*`raDQ\x83#Z\xd',
                   '\xab\xbe\xde\xa6\x80\x05oR8*\xe5H\xb2\xe4\xf3\xf3\x89A\xe7\x1c\xff\x8ax\xdb\x1f\xff\xe1\x8a\x1b3a\x03\x9f\xe7g\x02\xafi3Kz\x1el0;vR\xf46\x98\xfa\xd1\x15;\xb6\xc3t\xb4\xc7\xfb\x98E\x9c\xed',
                   '{\xcd\x9e\xd0\xef\xc8\x89\xfb0\x02\xc6\xcdcZ\xfe\x94\xd8\xfak\xbb\xeb\xab\x07a \x01\x80!\x14\x84fy\x8a\x1dq\xef\xeaH\xb9\xca\xef\xba\xcd\x1d}Gn\x98\xde\xa2YJ\xc0o\xd8]k\xca\xa4\xcd\x81\xf3-\x1',
                   '7\x8e\xe7g\xf1\x161\xba\xd2\x13\x80\xb0\x04I\xb1z\xcd\xa4<2\xbc\xdf\x1dw\xf8 \x12\xd40!\x9f\x9b]\x80\xef\x9d\x18\x91\xcc\x86\xe7\x1d\xa4\xaa\x88\xe1(R\xfa\xf4\x17\xd5\xd9\xb2\x1b\x99H\xbc\x92J\xf1\x1b\xd7 '].freeze
    # rubocop:enable Metrics/LineLength
  end
end
