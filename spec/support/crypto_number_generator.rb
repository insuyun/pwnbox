# encoding: utf-8

# Generate special number for testing
module CryptoNumberGenerator
  def self.generate_composite_of_close_primes(bits = 512, range = 65_536)
    loop do
      p = OpenSSL::BN.generate_prime(bits)

      2.step(range, 2).each do |x|
        q = p + x
        return (p * q).to_i if q.prime?
      end
    end
  end

  def self.generate_wiener_weak_key(bits = 1024)
    p, q = 2.times.map { OpenSSL::BN.generate_prime(bits / 2).to_i }

    n = p * q
    phi = (p - 1) * (q - 1)
    loop do
      d = OpenSSL::BN.generate_prime(bits / 8).to_i
      if small_d?(d, n) && Pwnbox::Number.gcd(d, phi)
        e = Pwnbox::Number.mod_inverse(d, phi)
        return [p, q, e]
      end
    end
  end

  private

  def self.small_d?(d, n)
    (3 * d)**4 < n
  end
end
