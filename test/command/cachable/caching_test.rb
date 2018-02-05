#!/usr/bin/ruby -w
# -*- ruby -*-

require 'command/cachable/caching'
require 'command/cachable/tc'
require 'paramesan'
require 'pathname_assertions'
require 'pathname'

module Command::Cachable
  class CachingCommandTestCase < CommandTestCase
    include Paramesan, PathnameAssertions

    # def setup
    #   @cmd = CachingCommand.new %w{ ls /bin }, dir: "/tmp/testcmd"
    # end
    
    # def create_testing_command_line args
    #   CachingCommand.new(*args)
    # end

    # def test_cache_dir_defaults_to_executable
    #   assert_equal CACHE_DIR, Pathname.new(@cmd.cache_dir)
    # end

    # def test_cache_file_defaults_to_executable
    #   assert_equal '/tmp/testcmd/ls-_slash_bin.gz', @cmd.cache_file.to_s
    # end

    # def test_cache_file_defaults_to_current_file
    #   cmd = CachingCommand.new %w{ ls /bin }
    #   dir = Pathname.new($0).expand_path
    #   assert_equal "/tmp#{dir}/ls-_slash_bin.gz", cmd.cache_file.to_s
    # end

    # def test_cache_dir_set_cachefile
    #   assert_not_nil @cmd.cache_dir
    #   refute_exists '/tmp/testcmd'
    #   assert_equal '/tmp/testcmd/ls-_slash_bin.gz', @cmd.cache_file.to_s
    # end

    # def test_cache_dir_created_on_execute
    #   refute_exists '/tmp/testcmd'
    #   @cmd.execute
    #   assert_exists '/tmp/testcmd'
    # end

    # def test_cache_file_matches_results
    #   cachefile = @cmd.cache_file

    #   @cmd.execute
    #   assert_exists '/tmp/testcmd'

    #   cachelines = read_gzfile cachefile
    #   syslines = IO.popen("ls /bin").readlines

    #   assert_equal syslines, cachelines
    # end
  end
end
