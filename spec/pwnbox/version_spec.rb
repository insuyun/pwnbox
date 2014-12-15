# encoding: utf-8
require 'spec_helper'

describe Pwnbox::Version do
  describe '::STRING' do
    it { expect(defined? subject::STRING).to eql('constant') }
  end
end
