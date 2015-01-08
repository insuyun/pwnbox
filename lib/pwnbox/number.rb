# encoding: utf-8
module Pwnbox
  # Number theory functions
  module Number
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

    def self.solve_quadratic_equation(a, b, c)
      # ax^2 + bx + c = 0
      x = b**2 - 4 * a * c
      r1 = (-b  + sqrt(x)) / (2 * a)
      r2 = (-b  - sqrt(x)) / (2 * a)

      [r1, r2]
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

    def self.chinese_remainder_theorem(remainders, mods)
      check_arguments_of_crt(remainders, mods)

      n = mods.reduce(&:*)
      x = 0

      mods.each_with_index do |ni, i|
        x += remainders[i] * n / ni * mod_inverse(n / ni, ni)
      end
      x % n
    end

    def self.mod_composite_sqrt(a, p, q)
      sqrt_p = mod_prime_sqrt(a, p)
      sqrt_q = mod_prime_sqrt(a, q)

      sqrt = []

      sqrt_p.each do |x|
        sqrt_q.each do |y|
          sqrt.push(chinese_remainder_theorem([x, y], [p, q]))
        end
      end

      sqrt
    end

    def self.bit_length(num)
      num.to_s(2).length
    end

    def self.sqrt(num)
      root = BigDecimal(num.to_s).sqrt(bit_length(num) * 2)
      if (root.round**2) == num
        # perfect square
        root.round
      else
        root.to_f
      end
    end

    def self.nth_root(x, n)
      # TODO : Support floating point
      low, high = bound(x, n)
      binary_search_nth_root(low, high, x, n)
    end

    def self.s_to_i(s)
      s = s.force_encoding('binary')
      s.unpack('H*')[0].to_i(16)
    end

    def self.i_to_s(i)
      [i.to_s(16)].pack('H*')
    end

    private

    def self.bound(x, n)
      high = 1
      high *= 2 while high**n < x
      [high / 2, high]
    end

    def self.binary_search_nth_root(low, high, x, n)
      while low < high
        mid = (low + high) / 2
        if low < mid && mid**n < x
          low = mid
        elsif high > mid && mid**n > x
          high = mid
        else
          return mid
        end
      end
    end

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

    def self.coprime?(p, q)
      gcd(p, q) == 1
    end

    def self.check_arguments_of_crt(remainders, mods)
      if remainders.length != mods.length
        fail ArgumentError, 'remainders and mods must have same length'
      end

      # check pairwise coprime
      mods.length.times do |i|
        (i + 1..mods.length - 1).each do |j|
          unless coprime?(mods[i], mods[j])
            fail ArgumentError, 'mods are not pairwise coprime'
          end
        end
      end
    end
  end
end
