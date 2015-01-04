# encoding: utf-8
module Pwnbox
  # Continued fraction
  module ContinuedFraction
    def self.to_contfrac(r)
      p, q = r
      a = p / q
      if (p % q == 0)
        return [p / q]
      else
        return [a] + to_contfrac([q, p - a * q])
      end
    end

    def self.to_rational(a)
      p = [nil] * (a.length + 2)
      q = [nil] * (a.length + 2)

      p[-1] = q[-2] = 1
      p[-2] = q[-1] = 0

      len = a.length

      len.times do |n|
        next_seq(a, p, n)
        next_seq(a, q, n)
      end

      [p[len - 1], q[len - 1]]
    end

    def self.convergents(r)
      c = to_contfrac(r)
      convs = []
      c.length.times do |i|
        convs.push(to_rational(c[0..i]))
      end
      convs
    end

    private

    def self.next_seq(a, p, n)
      p[n] = a[n] * p[n - 1] + p[n - 2]
    end
  end
end
