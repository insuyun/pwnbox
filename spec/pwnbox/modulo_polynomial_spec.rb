# encoding: utf-8
describe Pwnbox::ModuloPolynomial do
  describe '.gcd' do
    it { is_expected.to respond_to(:gcd) }

    it 'gives a gcd of polynomials' do
      p, q = 2.times.map { OpenSSL::BN.generate_prime(512).to_i }
      n = p * q

      a = []
      while a.length != 5
        a.push(rand(n))
        a.uniq!
      end

      args = [a[0..2], a[2..-1]]

      poly = args.map do |arg|
        [
          1,
          -arg.reduce(&:+),
          arg.combination(2).map { |v| v.reduce(&:*) }.reduce(&:+),
          -(arg.reduce(&:*))
        ]
      end

      gcd = ['gcd', 1, -a[2] % n]
      factor = ['integer_factorization', p, q]

      result = subject.gcd(poly[0], poly[1], n)

      if (result[0] == 'gcd')
        expect(result).to match_array(gcd)
      else
        expect(result).to match_array(factor)
      end
    end
  end
end
