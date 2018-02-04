#!/usr/bin/ruby -w
# -*- ruby -*-

require 'command/cachable/caching'
require 'command/cachable/tc'
require 'paramesan'
require 'pathname_assertions'

module Command::Cachable
  class CachingCommandLineTestCase < CommandTestCase
    include Paramesan, PathnameAssertions

    def setup
      @cmdline = CachingCommandLine.new %w{ ls /bin }, dir: "/tmp/testcmdline"
    end
    
    def create_testing_command_line args
      CachingCommandLine.new(*args)
    end

    def test_cache_dir_defaults_to_executable
      assert_equal CACHE_DIR, Pathname.new(@cmdline.cache_dir)
    end

    def test_cache_file_defaults_to_executable
      assert_equal '/tmp/testcmdline/ls-_slash_bin.gz', @cmdline.cache_file.to_s
    end

    def test_cache_dir_set_cachefile
      assert_not_nil @cmdline.cache_dir
      refute_exists '/tmp/testcmdline'
      assert_equal '/tmp/testcmdline/ls-_slash_bin.gz', @cmdline.cache_file.to_s
    end

    def test_cache_dir_created_on_execute
      refute_exists '/tmp/testcmdline'
      @cmdline.execute
      assert_exists '/tmp/testcmdline'
    end

    def test_cache_file_matches_results
      cachefile = @cmdline.cache_file

      @cmdline.execute
      assert_exists '/tmp/testcmdline'

      cachelines = read_gzfile cachefile
      syslines = IO.popen("ls /bin").readlines

      assert_equal syslines, cachelines
    end
  end
end
