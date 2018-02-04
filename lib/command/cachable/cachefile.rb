#!/usr/bin/ruby -w
# -*- ruby -*-

require 'command/cachable/line'
require 'command/cachable/filename'
require 'command/cachable/gzpathname'

module Command::Cachable
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
    
    def readlines
      if @pathname.exist?
        @output = @pathname.read_file
      else
        cl = CommandLine.new @args
        @output = cl.execute
        @pathname.save_file @output
        @output
      end
    end

    def to_s
      @pathname.to_s
    end
  end
end
