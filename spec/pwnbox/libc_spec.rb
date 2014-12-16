# encoding: utf-8
require 'spec_helper'

describe Pwnbox::Libc do
  let(:libc_name) { 'd6f77e544734e61247fe2e91575d954decf1f646' }
  subject(:libc) { described_class.new(libc_name) }
  describe '#name' do
    it { is_expected.to respond_to(:name) }

    it 'gives the initialized name' do
      expect(subject.name).to be(libc_name)
    end
  end

  describe '#path' do
    it { is_expected.to respond_to(:path) }

    it 'gives the real path of file' do
      expect(File.exist?(subject.path)).to be true
    end
  end

  describe '#find_address_by_name' do
    it { is_expected.to respond_to(:find_address_by_name) }

    it 'gives the address of function name' do
      name_address_pairs = [
        ['system', 0x00040100], ['__libc_start_main', 0x00019990],
        ['read', 0x000DB4B0]]

      name_address_pairs.each do |pair|
        expect(subject.find_address_by_name(pair[0])).to be pair[1]
      end
    end
  end

  describe '#address?' do
    it { is_expected.to respond_to(:address?) }

    it 'checks the address disregarding aslr' do
      name = '__libc_start_main'
      address = subject.find_address_by_name('__libc_start_main')
      low_address = address & 0xfff
      random_high_address = rand(0x1000000) << 12
      correct_address = low_address + random_high_address
      wrong_address = low_address + random_high_address + rand(1..0xfff)

      expect(subject.address?(name, correct_address)).to be true
      expect(subject.address?(name, wrong_address)).to be false
    end
  end
end
