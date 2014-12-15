require 'pwnbox/libc'

module Pwnbox
  module LibcFinder
    def self.find(pairs)
      pairs = pairs.flatten
      possible_libc = []

      # return nil if pairs is odd number
      return nil if (pairs.length % 2) == 1 || pairs.length == 0


      Dir["#{LIBC_DIR}/**/*"].each do |name|
         if not File.directory? name
            libc = Libc.new(File.basename(name))
            results = pairs.each_slice(2).map {|v| libc.address?(v[0], v[1]) }
            possible_libc.push(libc) if results.reduce(:&)
         end
      end

      return possible_libc
    end
  end
end
