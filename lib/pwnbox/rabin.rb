# encoding: utf-8
module Pwnbox
  # Rabin cryptosystem
  module Rabin
    def self.encrypt(m, n)
      Number.pow(m, 2, n)
    end

    def self.decrypt(c, p, q)
      Number.mod_composite_sqrt(c, p, q)
    end

    def self.factorize(p, n)
      p.length.times do |i|
        ((i + 1)..p.length - 1).each do |j|
          g = Number.gcd(n, (p[i] - p[j]) % n)
          return [g, n / g] if g != 1
        end
      end
    end
  end
end
