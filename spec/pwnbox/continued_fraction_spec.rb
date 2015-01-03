# encoding: utf-8
describe Pwnbox::ContinuedFraction do
  describe '.to_contfrac' do
    rationals = [[27, 32], [16, 19], [11, 13], [5, 6], [4, 5], [3, 4]]
    contfracs = [
      [0, 1, 5, 2, 2], [0, 1, 5, 3], [0, 1, 5, 2],
      [0, 1, 5], [0, 1, 4], [0, 1, 3]
    ]

    it 'gives continued fraction of rational number' do
      rationals.each_with_index do |r, idx|
        expect(subject.to_contfrac(r)).to eql(contfracs[idx])
      end
    end
  end

  describe '.to_rational' do
    it 'reverse to_confrac' do
      r1 = rand(1..1000)
      r2 = rand(1..1000)
      d = r1.gcd(r2)
      confrac = subject.to_contfrac([r1 / d, r2 / d])
      rational = subject.to_rational(confrac)
      expect(rational).to eq([r1 / d, r2 / d])
    end
  end

  describe '.convergents' do
    it 'gives convergents of rational numbers' do
      # http://en.wikipedia.org/wiki/Wiener's_attack
      convs = [
        [1, 5], [29, 146], [117, 589], [146, 735], [555, 2_794],
        [1_256, 6_323], [5_579, 28_086], [17_993, 90_581]
      ]
      calced = subject.convergents([17_993, 90_581])

      convs.each do |conv|
        expect(calced).to include(conv)
      end
    end
  end
end
