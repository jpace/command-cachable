#!/usr/bin/ruby -w
# -*- ruby -*-

require 'command/cacheable/command'
require 'command/cacheable/cachefile'

module Command::Cacheable
  class CachingCommand < Command
    # caches its input and values.

    def initialize *args, debug: false, dir: nil
      @args = args.dup
      @dir = dir || '/tmp' + Pathname.new($0).expand_path.to_s
    end

    def cache_dir
      @dir
    end

    def cache_file
      CacheFile.new cache_dir, @args
    end

    def execute
      cachefile = cache_file
      @output = cachefile.read
    end
  end
end
