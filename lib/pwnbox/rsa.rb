# encoding: utf-8
module Pwnbox
  # RSA attacks
  module RSA
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
  end
end
