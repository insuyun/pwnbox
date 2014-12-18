# encoding: utf-8
module Pwnbox
  # For crypto problem
  module Crypto
    # http://rosettacode.org/wiki/Modular_inverse#Ruby
    def self.extended_gcd(a, b)
      last_remainder, remainder = [a, b].map(&:abs)
      numbers = [0, 1, 1, 0]
      while remainder != 0
        last_remainder, (quotient, remainder) =
          remainder, last_remainder.divmod(remainder)
        numbers = next_numbers(numbers, quotient)
      end

      [last_remainder, invert_sign(numbers[1], a), invert_sign(numbers[3], b)]
    end

    def self.gcd(a, b)
      extended_gcd(a, b)[0]
    end

    def self.solve_linear_congruence_equation(a, b, m)
      egcd = extended_gcd(a, m)
      (egcd[1] * b / egcd[0]) % m if (b  % egcd[0]) == 0
    end

    def self.mod_inverse(a, m)
      egcd = extended_gcd(a, m)
      egcd[1] % m if egcd[0] == 1
    end

    def self.mod_prime_sqrt(a, p)
      if !prime?(p) || p % 4 == 1
        fail ArgumentError, 'p must be a prime where p % 4 == 3'
      end

      if pow(a, (p - 1) / 2, p) == p - 1
        fail ArgumentError, "#{a} is not quadratic residue"
      end

      root = pow(a, (p + 1) / 4, p)
      [root, p - root]
    end

    private

    def self.pow(val, exp, mod)
      val.to_bn.mod_exp(exp, mod).to_i
    end

    def self.invert_sign(x, a)
      x * (a < 0 ? -1 : 1)
    end

    def self.next_numbers(numbers, quotient)
      numbers.each_slice(2).map { |v| [v[1] - quotient * v[0], v[0]] }.flatten
    end

    def self.prime?(p)
      p.to_bn.prime?
    end
  end
end
