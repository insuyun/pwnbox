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
    libc = Pwnbox::LibcFinder.find(['system', 0x40100])
    puts "Path : #{libc.path}"
    puts "Read address : 0x%08X" % libc.find_address_by_name('read')
```
