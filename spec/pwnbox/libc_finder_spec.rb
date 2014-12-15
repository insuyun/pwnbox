# encoding: utf-8
require 'spec_helper'

describe Pwnbox::LibcFinder do
  before { @libc_name = 'd6f77e544734e61247fe2e91575d954decf1f646' }

  describe '.find' do
    it { is_expected.to respond_to(:find) }

    context 'with a pair' do
      it 'gives the array of libc which contains the function' do
        input = ['system', 0x40100]
        expect(subject.find(input).map(&:name)).to include(@libc_name)
      end
    end

    context 'with multiple pairs' do
      it 'gives the array of libc which contains the function' do
        input = [['system', 0x40100], ['__libc_start_main', 0x19990]]
        expect(subject.find(input).map(&:name)).to include(@libc_name)
      end
    end

    it 'gives [] when no libc has been found' do
      inputs = [
        ['system', 0xffff], ['wrong', 0x40100],
      ]

      inputs.each do |input|
        expect(subject.find(input)).to be_empty
      end
    end

    it 'gives nil when input format is wrong' do
      inputs = [
        ['wrong'], [['system', 0x40100], ['__libc_start_main']]
      ]
      inputs.each do |input|
        expect(subject.find(input)).to be_nil
      end
    end
  end
end
