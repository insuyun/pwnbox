describe Pwnbox::ElGamal do
  describe '.decrypt' do
    it 'decrypt through ElGamal algorithm' do
      pub, priv  = subject.generate_key
      m = rand(pub.p)
      expect(priv.decrypt(pub.encrypt(m))).to eq(m)
    end
  end
end
