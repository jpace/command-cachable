#!/usr/bin/ruby -w
# -*- ruby -*-

require 'command/cachable/line'
require 'command/cachable/cachefile'

module Command::Cachable
  class CachingCommandLine < CommandLine
    # caches its input and values.

    def initialize *args, debug: false, dir: nil
      @args = args.dup
      @dir = dir
    end

    def cache_dir
      # @cache_dir ||= '/tmp' + Pathname.new($0).expand_path.to_s
      @dir
    end

    def cache_file
      CacheFile.new cache_dir, @args
    end

    def execute
      cachefile = cache_file
      @output = cachefile.readlines
    end
  end
end
