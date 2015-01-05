# encoding: utf-8
describe Pwnbox::Polynomial do
  describe '.gcd' do
    it { is_expected.to respond_to(:gcd) }

    it 'gives a gcd of polynomials' do
      polynomials = [
        [[1, 7, 6], [1, -5, -6]],
        [[1, 8, 21, 22, 8], [1, 6, 11, 6]]
      ]

      gcds = [
        [1, 1],
        [1, 3, 2]
      ]

      polynomials.each_with_index do |poly, i|
        expect(subject.gcd(poly[0], poly[1])).to eql(gcds[i])
      end
    end
  end
end
