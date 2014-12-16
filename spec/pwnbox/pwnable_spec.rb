# encoding: binary
require 'spec_helper'

describe Pwnbox::Pwnable do
  describe '.fsb' do
    it { is_expected.to respond_to(:fsb) }

    it 'generates a format string bug payload' do
      target = 0x804a014
      # diff = difference between buffer and esp
      diff = 0xbffff30c - 0xbffff2f0
      value = [0xdeadbeef].pack('<I')
      expected = "\x14\xa0\x04\x08\x15\xa0\x04\x08"\
                 "\x16\xa0\x04\x08\x17\xa0\x04\x08"\
                 '%223c%7$n%207c%8$n%239c%9$n%49c%10$n'
      expect(subject.fsb(target, diff, value)).to eq(expected)
    end
  end

  describe '.find_libc' do
    before { @libc_name = 'd6f77e544734e61247fe2e91575d954decf1f646' }

    it { is_expected.to respond_to(:find_libc) }

    context 'with a pair' do
      it 'gives the array of libc which contains the function' do
        input = ['system', 0x40100]
        expect(subject.find_libc(input).map(&:name)).to include(@libc_name)
      end
    end

    context 'with multiple pairs' do
      it 'gives the array of libc which contains the function' do
        input = [['system', 0x40100], ['__libc_start_main', 0x19990]]
        expect(subject.find_libc(input).map(&:name)).to include(@libc_name)
      end
    end

    it 'gives [] when no libc has been found' do
      inputs = [
        ['system', 0xffff], ['wrong', 0x40100]
      ]

      inputs.each do |input|
        expect(subject.find_libc(input)).to be_empty
      end
    end

    it 'gives nil when input format is wrong' do
      inputs = [
        ['wrong'], [['system', 0x40100], ['__libc_start_main']]
      ]
      inputs.each do |input|
        expect(subject.find_libc(input)).to be_nil
      end
    end
  end

end
