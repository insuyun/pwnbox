# encoding: utf-8
module Pwnbox
  # Retreive the function address from binary
  class Libc
    attr_reader :name, :path

    def initialize(name)
      @name = name
      @path = libc_path
    end

    def libc_path
      Dir["#{Pwnbox.libc_dir}/**/*"].each do |file|
        basename = File.basename(file)
        return File.expand_path(file) if basename == @name
      end
    end

    def find_address_by_name(name)
      symbols = `readelf -s #{path}`.split("\n").map(&:split)
      symbols.each do |symbol|
        # symbol[1] : Symbol address
        # Symbol[7] : Symbol name
        if symbol[7] && symbol[7].start_with?("#{name}@")
          return symbol[1].to_i(16)
        end
      end

      nil
    end

    def address?(name, address)
      (find_address_by_name(name) & 0xfff) == (address  & 0xfff)
    end
  end
end
