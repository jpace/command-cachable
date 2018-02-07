#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/loggable'
require 'open3'
require 'command/cachable/cachefile'

module Command
  module Cachable
  end
end

module Command::Cachable
  # A command line executable, by default not caching.
  class Command
    include Logue::Loggable

    attr_reader :args
    attr_reader :output
    attr_reader :error
    attr_reader :status

    def initialize *args, debug: false, caching: false
      @args = args.dup
      @caching = caching
    end

    def << arg
      @args << arg
    end

    def execute
      if @caching
        read_cache_file
      else
        exec
      end
    end

    def exec
      cmd = to_command
      Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thread|
        @output = stdout.readlines
        @error  = stderr.readlines
        @status = wait_thread.value
      end

      #$$$ this functionality isn't in Logue yet (dump of one element per line):
      # debug "output", @output
      # debug "error", @error

      debug "@status: #{@status}"      
      
      @output
    end

    def read_cache_file
      cachedir = @dir || "/tmp/cachetest"
      cachefile = CacheFile.new cachedir, @args
      if cachefile.pathname.exist?
        @output = cachefile.pathname.read_file
      else
        exec
        cachefile.pathname.save_file @output
        @output
      end
    end

    def to_command
      @args.join ' '
    end
  end
end
