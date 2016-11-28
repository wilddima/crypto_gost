module CryptoGost
  # ModularArithmetic
  #
  # Take this code from here: https://gist.github.com/jingoro/2388745
  # @author jingoro
  module DigitalSignatureGost12
    module ModularArithmetic

      module_function

      def gcd(x, y)
        gcdext(x, y).first
      end

      def gcdext(x, y)
        if x < 0
          g, a, b = gcdext(-x, y)
          return [g, -a, b]
        end
        if y < 0
          g, a, b = gcdext(x, -y)
          return [g, a, -b]
        end
        r0, r1 = x, y
        a0 = b1 = 1
        a1 = b0 = 0
        until r1.zero?
          q = r0 / r1
          r0, r1 = r1, r0 - q*r1
          a0, a1 = a1, a0 - q*a1
          b0, b1 = b1, b0 - q*b1
        end
        [r0, a0, b0]
      end

      def invert(num, mod)
        g, a, b = gcdext(num, mod)
        unless g == 1
          raise ZeroDivisionError.new("#{num} has no inverse modulo #{mod}")
        end
        a % mod
      end

      def powmod(base, exp, mod)
        if exp < 0
          base = invert(base, mod)
          exp = -exp
        end
        result = 1
        multi = base % mod
        until exp.zero?
          result = (result * multi) % mod if exp.odd?
          exp >>= 1
          multi = (multi * multi) % mod
        end
        result
      end
    end
  end
end