#!/usr/bin/ruby -w
# -*- ruby -*-

# require 'command/cacheable/command'
require 'command/cacheable/filename'
require 'command/cacheable/gzpathname'

module Command::Cacheable
  # A file that has a pathname and output
  #$$$ todo: cache error
  class CacheFile
    attr_reader :output
    attr_reader :pathname
    
    def initialize cache_dir, args
      @args     = args
      basename  = FileName.new(args).name
      fullname  = Pathname(cache_dir) + basename
      @pathname = GzipPathname.new fullname
      @output   = nil
    end
    
    def read
      @output = @pathname.exist? && @pathname.read_file
    end

    def save output
      @pathname.save_file output
    end

    def to_s
      @pathname.to_s
    end
  end
end
