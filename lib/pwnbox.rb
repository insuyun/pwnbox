# encoding: utf-8
require 'openssl'
require 'bigdecimal'
require 'pwnbox/version'
require 'pwnbox/libc'
require 'pwnbox/pwnable'
require 'pwnbox/crypto'
require 'pwnbox/aes'

# Module global methods and constants
module Pwnbox
  LIBC_DIR = 'assets/libc'

  def self.libc_dir
    "#{File.dirname(__FILE__)}/../#{LIBC_DIR}"
  end
end
