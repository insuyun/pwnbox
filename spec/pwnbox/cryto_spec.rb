# encoding: utf-8
require 'spec_helper'

describe Pwnbox::Crypto do

  describe 'gcd' do
    it { is_expected.to respond_to('gcd') }

    it 'gives the gcd of two numbers' do
      rand_val = rand(1..100)
      tests = [
        [1, 1, 1], [rand_val, rand_val * rand(1..100), rand_val],
        [8, 18, 2], [9, 100, 1]
      ]

      tests.each do |test|
        expect(subject.gcd(test[0], test[1])).to be(test[2])
      end
    end
  end

  describe 'extended_gcd' do
    it { is_expected.to respond_to('extended_gcd') }

    it 'gives the [gcd, x, y] where ax + by = gcd where (a,b) is given' do
      rand_val = rand(1..100)
      tests = [
        [1, 1, 1], [rand_val, rand_val * rand(1..100), rand_val],
        [8, 18, 2], [9, 100, 1]
      ]

      tests.each do |test|
        extended_gcd = subject.extended_gcd(test[0], test[1])
        calculated_gcd = extended_gcd[1] * test[0] + extended_gcd[2] * test[1]

        expect(extended_gcd[0]).to be(test[2])
        expect(calculated_gcd).to be(test[2])
      end
    end

  end

  describe 'solve_linear_congruence_equation' do
    it { is_expected.to respond_to('solve_linear_congruence_equation') }

    it 'gives the root of "ax = b (mod m)" ' do
      expect(subject.solve_linear_congruence_equation(3,4,5)).to be(3)
      expect(subject.solve_linear_congruence_equation(151,338,7)).to be(4)
    end

    it 'gives nil when there is no root of the equation' do
      expect(subject.solve_linear_congruence_equation(3, 4, 9)).to be_nil
    end
  end

  describe 'mod_inverse' do
    it { is_expected.to respond_to('mod_inverse') }

    it 'gives the modular inverse of a mod m' do
      tests = [[3, 11, 4], [3, 7, 5]]
      tests.each do |test|
        expect(subject.mod_inverse(test[0], test[1])).to be(test[2])
      end
    end

    it 'gives nil when impossible to find modular inverse' do
      tests = [[2,4], [3, 12], [9, 30]]
      tests.each do |test|
        expect(subject.mod_inverse(test[0], test[1])). to be_nil
      end
    end
  end
end
