require 'pwnbox/version'
require 'pwnbox/libc'
require 'pwnbox/pwnable'

# Module global methods and constants
module Pwnbox
  LIBC_DIR = 'assets/libc'

  def self.libc_dir
    "#{File.dirname(__FILE__)}/../#{LIBC_DIR}"
  end
end
