# Pwnbox

[![Build Status](https://travis-ci.org/jakkdu/pwnbox.svg?branch=master)](https://travis-ci.org/jakkdu/pwnbox)

Capture-The-Flag(CTF) toolkit

## Installation

Add this line to your application's Gemfile:

    gem 'pwnbox'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pwnbox

## Usage

### Find a libc.so

```ruby
libc = Pwnbox::Pwnable.find_libc(['system', 0x40100])
puts "Path : #{libc.path}"
puts "Read address : 0x%08X" % libc.find_address_by_name('read')
```

### Format string bug

An example is following.

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(int argc, char** argv)
{
    char buf[0x100];
    strncpy(buf, argv[1], 40);
    printf(buf);
    exit(-1);
}
```

```shell
=> 0x080484c7 <+74>:    call   0x8048330 <printf@plt>
(gdb) x/i 0x8048350
   0x8048350 <exit@plt>:        jmp    *0x804a014
(gdb) x/x $esp
0xbffff2f0:     0xbffff30c
```

```ruby
Pwnbox::Pwnable.fsb(0x804a014, 0xbffff30c - 0xbffff2f0, [0xdeadbeef].pack('<I'))
```

### Number theory
```ruby
Pwnbox::Number.gcd(a, b)

# return [gcd, x, y] where x * a + y * b = gcd
Pwnbox::Number.extended_gcd(a, b)

# solve ax = b mod m
Pwnbox::Number.solve_linear_congruence_equation(a, b, m)

# return a^-1 mod n
Pwnbox::Number.mod_inverse(a, n)

# return x where x^2 = a mod p
Pwnbox::Number.mod_prime_sqrt(a, p)

# return x where x^2 = a mod p * q
Pwnbox::Number.mod_composite_sqrt(a, p, q)

# chinese remainder theorem
Pwnbox::Number.chinese_remainder_theorem([a1, a2, a3], [n1, n2, n3])

# nth root, works for big integer which is pefect n square
Pwnbox::Number.nth_root(a)
```

### RSA
```ruby
# factorize if p, q is close
Pwnbox::RSA::factorize_if_close_prime(n)

# find non trivial factors
Pwnbox::RSA::find_nontrivial_factors([n1, n2, ...])

# Wiener's attack
Pwnbox::RSA::wiener(e, n)

# Weak Hastad's broadcast attack (Only for same plaintext)
Pwnbox::RSA::weak_hastad([c_1, c_2, ..., c_e], [n_1, n_2, ..., n_e])

# Franklin-Reiter related message attack for m2 = a * m1 + b
Pwnbox::RSA::franklin_reiter(a, b, c1, c2, n)
```

### ElGamal
```ruby
# encrypt
pub = Pwnbox::ElGamal::PubKey.new(p, g, h)
pub.encrypt(m)

# decrypt
priv = Pwnbox::ElGamal::PrivKey.new(p, g, x)
priv.decrypt(c)
```

### Rabin
```ruby
# encrypt
Pwnbox::Rabin.encrypt(m, n)

# decrypt
Pwnbox::Rabin.decrypt(c, p, q)

# factorize if two plaintexts are given
Pwnbox::Rabin.factorize([r, s])
```

### AES
```ruby
# inverse round key
Pwnbox::AES.inverse_round_key(round_key)
```
