#!/usr/bin/ruby -w
# -*- ruby -*-

require 'command/cachable/line'
require 'test_helper'
require 'paramesan'
require 'tempfile'

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
      cl = CommandLine.new cmd
      cl.execute
      assert_equal exp_output, cl.output
    end
    
    param_test build_execute_params do |exp_output, exp_error, exp_status, cmd|
      cl = CommandLine.new cmd
      cl.execute
      assert_equal exp_error, cl.error
    end
    
    param_test build_execute_params do |exp_output, exp_error, exp_status, cmd|
      cl = CommandLine.new cmd
      cl.execute
      assert_equal exp_status, cl.status.exitstatus
    end

    # def test_output_valid
    #   tf = Tempfile.new
    #   cl = CommandLine.new %w{ ls /tmp }
    #   cl.execute
    #   refute_nil cl.output.detect { |x| tf.path.index x.chomp }
    # end

    # def test_output_invalid
    #   tf = Tempfile.new
    #   cmd = %w{ ls /tmp }
    #   cmd << tf.path
    #   cl = CommandLine.new cmd
    #   cl.execute
    #   refute_nil cl.output.detect { |x| tf.path.index x.chomp }
    # end

    # def test_error_existing
    #   tf = Tempfile.new
    #   cmd = %w{ ls /tmp/doesnotexist }
    #   puts "cmd: #{cmd}"
    #   cl = CommandLine.new cmd
    #   cl.execute

    #   puts "output"
    #   puts cl.output
    #   puts "error"
    #   puts cl.error
      
    #   assert_empty cl.output
    #   # assert_empty cl.error
    # end

    # def test_error_and_output
    #   tf = Tempfile.new
    #   cmd = %w{ ls /tmp/doesnotexist }
    #   cmd << tf.path

    #   cl = CommandLine.new cmd
    #   cl.execute

    #   puts "output"
    #   puts cl.output
    #   puts "error"
    #   puts cl.error
      
    #   refute_empty cl.output
    #   refute_empty cl.error
    # end
  end
end
