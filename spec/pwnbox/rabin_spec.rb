describe Pwnbox::Rabin do
  describe '.decrypt' do
    it 'decrypt the encrypted message' do
      p, q = 2.times.map { OpenSSL::BN.generate_prime(512).to_i }
      n = p * q
      m = rand(n)
      c = subject.encrypt(m, n)

      expect(subject.decrypt(c, p, q)).to include(m)
    end
  end

  describe 'factorize' do
    it 'factorize with multiple plaintexts of a ciphertext' do
      p, q = 2.times.map { OpenSSL::BN.generate_prime(512).to_i }
      n = p * q
      c = subject.encrypt(rand(n), n)
      m = subject.decrypt(c, p, q)

      expect(subject.factorize(m, n)).to match_array([p, q])
    end
  end
end
