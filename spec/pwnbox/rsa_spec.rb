# encoding: utf-8
describe Pwnbox::RSA do
  include CryptoNumberGenerator

  describe 'factorize_if_close_prime' do
    it { is_expected.to respond_to('factorize_if_close_prime') }

    it 'gives factorized value if its factor is close prime' do
      n = CryptoNumberGenerator.generate_composite_of_close_primes
      p = subject.factorize_if_close_prime(n)[0]
      expect(n % p == 0).to be true
    end

    it 'gives nil if it is not close prime' do
      p = OpenSSL::BN.generate_prime(512).to_i
      q = OpenSSL::BN.generate_prime(256).to_i
      n = p * q
      expect(subject.factorize_if_close_prime(n)).to be_nil
    end
  end

  describe 'find_nontrivial_factors' do
    it { is_expected.to respond_to('find_nontrivial_factors') }

    p = OpenSSL::BN.generate_prime(512).to_i
    q = OpenSSL::BN.generate_prime(512).to_i
    r = OpenSSL::BN.generate_prime(512).to_i

    it 'gives factors with index if it has nontrivial vectors' do
      res = subject.find_nontrivial_factors([p * q, q * r, r * p])
      expect(res).to include([0, 1, q])
      expect(res).to include([0, 2, p])
      expect(res).to include([1, 2, r])
    end

    it 'gives nil if there is no factors' do
      expect(subject.find_nontrivial_factors([p, q, r])).to be_nil
    end
  end
end
