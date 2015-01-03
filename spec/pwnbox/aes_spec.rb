# encoding: utf-8
describe Pwnbox::AES do
  describe '.inverse_round_key' do
    it { is_expected.to respond_to(:inverse_round_key) }

    it 'gives original key from round key' do
      keys = %w(00000000000000000000000000000000
                41414141414141414141414141414141)
      round_keys = %w(b4ef5bcb3e92e21123e951cf6f8f188e
                      a24fd58526e7d1bb483c7f3293b24741)

      keys.each_with_index do |key, index|
        key = [key].pack('H*')
        round_key = [round_keys[index]].pack('H*')

        expect(subject.inverse_round_key(round_key)).to eq(key)
      end
    end
  end
end
