# encoding: utf-8
module Pwnbox
  # For crypto problem
  module Crypto

    # http://rosettacode.org/wiki/Modular_inverse#Ruby
    def self.extended_gcd(a, b)
      last_remainder, remainder = a.abs, b.abs
      x, last_x, y, last_y = 0, 1, 1, 0
      while remainder != 0
        last_remainder, (quotient, remainder) \
                    = remainder, last_remainder.divmod(remainder)
        x, last_x = last_x - quotient*x, x
        y, last_y = last_y - quotient*y, y
      end

      gcd = last_remainder
      x = last_x * (a < 0 ? -1 : 1)
      y = last_y * (b < 0 ? -1 : 1)
      return gcd, x, y
    end

    def self.gcd(a, b)
      extended_gcd(a,b)[0]
    end

    def self.solve_linear_congruence_equation(a, b, m)
      egcd = extended_gcd(a, m)
      if (b  % egcd[0]) == 0
        (egcd[1] * b / egcd[0]) % m
      else
        # no solution when b is not divisible by gcd(a,m)
        nil
      end
    end

    def self.mod_inverse(a, m)
      egcd = extended_gcd(a, m)
      if egcd[0] == 1
        egcd[1] % m
      else
        nil
      end
    end
  end
end
