#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/loggable'
require 'open3'

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

    def initialize *args, debug: false
      @args = args.dup
    end

    def << arg
      @args << arg
    end

    def execute
      cmd = to_command
      debug "cmd: #{cmd}"
      
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

    def to_command
      @args.join ' '
    end
  end
end
