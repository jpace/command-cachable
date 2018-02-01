#!/usr/bin/ruby -w
# -*- ruby -*-

require 'command/cachable/line'
require 'test_helper'
require 'paramesan'

module Command::Cachable
  class CommandLineTestCase < Test::Unit::TestCase
    include Paramesan

    def create args
      CommandLine.new(*args)
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
    
    param_test [
      [ true,  "ls", "/tmp" ],
      [ false, "ls", "/doesntexist" ]
    ] do |exp, *args|
      cl = create args
      cl.execute
      assert_equal exp, cl.status.success?, "args: #{args}"
    end
  end
end
