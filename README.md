# Command::Cacheable

Command::Cacheable wraps the command line, optionally caching standard output for later, faster
retrieval.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'command-cacheable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install command-cacheable

## Usage

From the [Svnx](https://github.com/jpace/svnx) project:

``` ruby
    require 'command/cacheable/command'
    ls = Command::Cacheable::Command.new [ "ls", "/tmp" ]
    ls.execute
    
    lsc = Command::Cacheable::Command.new [ "ls", "/tmp" ], caching: true, cachedir: "/tmp/lscache"
    lsc.execute

    diff = lsc.output - ls.output
```

`Command::Cacheable` is specifically for caching commands, and does not have the flexibility that
the [Command](https://github.com/collectiveidea/command) gem does. For one, it does not cache
standard error.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jpace/command-cacheable.

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).
