require 'pwnbox/version'
require 'pwnbox/libc'
require 'pwnbox/libc_finder'

module Pwnbox
  LIBC_DIR = 'assets/libc'

  def self.libc_dir
    "#{File.dirname(__FILE__)}/../#{LIBC_DIR}"
  end
end
