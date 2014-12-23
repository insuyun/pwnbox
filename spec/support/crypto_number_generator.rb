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
end
