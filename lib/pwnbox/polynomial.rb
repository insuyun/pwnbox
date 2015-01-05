# encoding: utf-8
module Pwnbox
  # Polynomial
  module Polynomial
    def self.gcd(a, b)
      # Only integer polynomial gcd
      a, b = b, a if deg(b) > deg(a)
      # Base case
      if b.empty?
        a.map { |v| (v / a[0]).to_i }
      else
        gcd(b, remainder(a, b))
      end
    end

    private

    def self.deg(a)
      a.length
    end

    def self.remainder(a, b)
      a, b = b, a if deg(b) > deg(a)
      b = b.map { |v| v * a[0] / Float(b[0]) }
      r = a.each_with_index.map do |v, i|
        if b[i]
          v - b[i]
        else
          v
        end
      end
      r[leading_deg(r)..-1]
    end

    def self.leading_deg(a)
      deg = 0
      a.each do |v|
        break if v != 0
        deg += 1
      end
      deg
    end
  end
end
