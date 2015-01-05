# encoding: utf-8
module Pwnbox
  # Polynomial
  module ModuloPolynomial
    def self.gcd(a, b, n)
      if b.empty?
        return normalized_gcd(a, n)
      elsif b[0] == 'integer_factorization'
        return b
      end
      # Only integer polynomial gcd
      a, b = b, a if deg(b) > deg(a)
      gcd(b, remainder(a, b, n), n)
    end

    def self.cube_of_linear_equation_with_constant(a, b, c)
      [a**3, 3 * (a**2) * b, 3 * a * (b**2), (b**3) - c]
    end

    private

    def self.deg(a)
      a.length
    end

    def self.remainder(a, b, n)
      # a % b
      a, b = b, a if deg(b) > deg(a)
      d = inverse_or_factorize(b[0], n)
      return d if d.is_a? Array

      while deg(b) <= deg(a)
        leading_factor = a[0]
        b.each_with_index { |v, i| a[i] = (a[i] - v * d * leading_factor) % n }
        slice_until_nonzero(a)
      end
      a
    end

    def self.slice_until_nonzero(a)
      a.slice!(0) while !a.empty? && a[0] == 0
    end

    def self.poly_to_bigdecimal_poly(s)
      s.map { |v| Rational(v) }
    end

    def self.inverse_or_factorize(x, n)
      d = Number.gcd(x, n)
      if d == 1
        return Number.mod_inverse(x, n)
      else
        return ['integer_factorization', d, n / d]
      end
    end

    def self.normalized_gcd(a, n)
      d = inverse_or_factorize(a[0], n)
      if d.is_a? Array
        d
      else
        ['gcd'] + a.map { |v| (v * d) % n }
      end
    end
  end
end
