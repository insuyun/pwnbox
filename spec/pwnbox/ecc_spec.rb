describe Pwnbox::ECC do
  describe Pwnbox::ECC::Point do
    let(:curve) { Pwnbox::ECC::Curve.new(17, [1, 7]) }
    let(:p) { curve.point(2, 0) }
    let(:q) { curve.point(1, 3) }
    let(:r) { curve.point(6, 12) }
    let(:zero) { curve.point(Float::INFINITY, Float::INFINITY) }

    it '.equal?' do
      expect(p.equal? p).to be true
      expect(p.equal? p.dup).to be true
      expect(p.equal? q).not_to be true
    end

    it '.add' do
      expect(p.add(q).equal? r).to be true
      expect(p.add(q).equal? p).to be false
      expect(p.add(zero).equal? p).to be true
      expect(p.add(zero).equal? q).to be false
      expect(p.add(p.inverse).equal? zero).to be true
      expect(q.add(q).equal? curve.point(6, 5)).to be true

      # Commutativity
      expect(p.add(q).equal? q.add(p)).to be true
      expect(p.add(q.add(r)).equal? p.add(q).add(r)).to be true
    end

    it 'mult' do
      num = 4
      sum = q
      (num - 1).times do
        sum = sum.add(q)
      end

      expect(sum.equal? q.mult(num)).to be true
    end
  end
end
