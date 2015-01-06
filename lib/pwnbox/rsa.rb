# encoding: utf-8
module Pwnbox
  # RSA attacks
  module RSA
    def self.generate_key(bits = 1024, e = 0x10001)
      p, q = 2.times.map { OpenSSL::BN.generate_prime(bits / 2).to_i }
      n = p * q
      d = Number.mod_inverse(e, (p - 1) * (q - 1))
      return [p, q, n, d]
    end

    def self.factorize_if_close_prime(n, trials = 65_536)
      bits = n.to_s(2).length
      sqrt = BigDecimal(n.to_s).sqrt(bits).to_i

      trials.times do |i|
        p = sqrt + i
        return [p, n / p] if n % p == 0
      end

      nil
    end

    def self.find_nontrivial_factors(arr)
      res = []

      arr.length.times do |i|
        (i + 1..arr.length - 1).each do |j|
          d = Number.gcd(arr[i], arr[j])
          res.push([i, j, d]) unless d == 1
        end
      end

      return nil if res.empty?
      res
    end

    def self.wiener(e, n)
      convs = ContinuedFraction.convergents([e, n])

      convs.each do |conv|
        k, d = conv
        phi = calc_phi(e, d, k)
        next unless phi
        p, q = Number.solve_quadratic_equation(1, -n + phi - 1, n).map(&:to_i)
        return [p.to_i, q.to_i] if p != 0 && n % p == 0
      end

      nil
    end

    def self.decrypt(c, p, q, e)
      d = Number.mod_inverse(e, (p - 1) * (q - 1))
      Number.pow(c, d, p * q)
    end

    def self.weak_hastad(ms, ns)
      n = Number.chinese_remainder_theorem(ms, ns)
      Number.nth_root(n, ms.length)
    end

    def self.franklin_reiter(a, b, c1, c2, n)
      # work only e = 3
      g1 = [1, 0, 0, -c1]
      g2 = ModuloPolynomial.cube_of_linear_equation_with_constant(a, b, c2)
      d = ModuloPolynomial.gcd(g2, g1, n)
      if d[0] == 'integer_factorization'
        decrypt(c1, p, q, 3)
      else
        -d[2] % n
      end
    end

    def self.weak_partial_key_exposure(n, e, low)
      r = rand(n)
      c = Number.pow(r, e, n)

      (1..e).each do |k|
        d = Rational(k * n + 1, e).round
        d >>= low.length
        d <<= low.length
        d |= low.to_i(2)
        return d if Number.pow(c, d, n) == r
      end
      nil
    end

    private

    def self.calc_phi(e, d, k)
      phi = e * d - 1
      if k == 0 || phi % k != 0
        nil
      else
        phi / k
      end
    end
  end
end
