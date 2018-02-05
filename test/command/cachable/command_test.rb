#!/usr/bin/ruby -w
# -*- ruby -*-

require 'command/cachable/command'
require 'test_helper'
require 'paramesan'
require 'tempfile'

module Command::Cachable
  class CommandTestCase < Test::Unit::TestCase
    include Paramesan, Logue::Loggable

    def create args
      Command.new(*args)
    end

    def execute args
      Command.new(args).tap do |cl|
        cl.execute
      end
    end
                
    param_test [
      [ [ "abc" ], "abc" ],
      [ [ "def" ], "def" ],
    ].each do |exp, *args|
      cl = create args
      assert_equal exp, cl.args
    end

    param_test [
      [ [ "abc"        ], [ "abc" ] ],
      [ [ "abc", "def" ], [ "abc" ], "def" ],
    ].each do |exp, args, *addl|
      cl = create args
      addl.each do |arg|
        cl << arg
      end
      assert_equal exp, cl.args
    end

    param_test [
      [ "abc",     "abc" ], 
      [ "abc def", "abc", "def" ], 
    ].each do |exp, *args|
      cl = create args
      assert_equal exp, cl.to_command
    end
    
    def self.build_execute_params
      @tf = Tempfile.new
      @tf.close
      Array.new.tap do |a|
        a << [ [ @tf.path + "\n" ], Array.new, 0, [ "ls", @tf.path ] ]
        a << [ Array.new, [ "ls: cannot access '/tmp/doesnotexist': No such file or directory\n" ], 2, %w{ ls /tmp/doesnotexist } ]
      end
    end
    
    param_test build_execute_params do |exp_output, exp_error, exp_status, cmd|
      assert_equal exp_output, execute(cmd).output
    end
    
    param_test build_execute_params do |exp_output, exp_error, exp_status, cmd|
      assert_equal exp_error, execute(cmd).error
    end
    
    param_test build_execute_params do |exp_output, exp_error, exp_status, cmd|
      assert_equal exp_status, execute(cmd).status.exitstatus
    end
    
    def self.build_caching_params
      @tf = Tempfile.new
      @tf.close
      Array.new.tap do |a|
        a << [ [ @tf.path + "\n" ], Array.new, 0, [ "ls", @tf.path ] ]
        # a << [ Array.new, [ "ls: cannot access '/tmp/doesnotexist': No such file or directory\n" ], 2, %w{ ls /tmp/doesnotexist } ]
      end
    end
    
    param_test build_caching_params do |exp_output, exp_error, exp_status, args|
      cl = Command.new args, caching: true
      cl.execute
      assert_equal exp_output, cl.output

      cachedir = "/tmp/cachetest"
      cachefile = CacheFile.new cachedir, args
      assert_true cachefile.pathname.exist?
    end
  end
end
