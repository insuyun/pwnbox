# encoding: utf-8
module Pwnbox
  # Elgmal encryption
  module ElGamal
    class PrivKey
      attr_reader :p, :g, :h, :x

      def initialize(p, g, h, x)
        @p, @g, @h, @x = p, g, h, x
      end

      def pubkey
        PubKey.new(p, g, h)
      end

      def decrypt(c)
        s = Number.pow(c[0], x, p)
        s_inv = Number.mod_inverse(s, p)
        (c[1] * s_inv) % p
      end
    end

    class PubKey
      attr_reader :p, :g, :h

      def initialize(p, g, h)
        @p, @g, @h = p, g, h
      end

      def encrypt(m)
        y = rand(1..p - 2)
        [Number.pow(g, y, p), (m * Number.pow(h, y, p)) % p]
      end
    end

    def self.generate_key(bits = 512)
      p = OpenSSL::BN.generate_prime(512).to_i
      g, x = 2.times.map { rand(2..p - 2) }
      h = Number.pow(g, x, p)
      pub = PubKey.new(p, g, h)
      priv = PrivKey.new(p,g, h, x)

      [pub, priv]
    end
  end
end
