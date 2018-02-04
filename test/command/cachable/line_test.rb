#!/usr/bin/ruby -w
# -*- ruby -*-

require 'command/cachable/line'
require 'test_helper'
require 'paramesan'
require 'tempfile'

module Command::Cachable
  class CommandLineTestCase < Test::Unit::TestCase
    include Paramesan, Logue::Loggable

    def create args
      CommandLine.new(*args)
    end

    def execute args
      CommandLine.new(args).tap do |cl|
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
      pn = Pathname.new @tf.path
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
  end
end
