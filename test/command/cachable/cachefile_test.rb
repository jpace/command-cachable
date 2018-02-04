#!/usr/bin/ruby -w
# -*- ruby -*-

require 'command/cachable/cachefile'
require 'command/cachable/tc'
require 'pathname_assertions'

module Command::Cachable
  class CacheFileTestCase < CommandTestCase
    include PathnameAssertions

    def create_cache_file *command
      CacheFile.new CACHE_DIR, command
    end

    def rm_cached_file cachefile
      pn = cachefile.pathname
      pn.unlink if pn.exist?
    end
    
    def test_creates_gzfile
      cf = create_cache_file "ls", "/var/spool"
      
      rm_cached_file cf
      refute_exists cf.pathname
      
      output = cf.read
      assert_exists cf.pathname

      fromgz = read_gzfile cf.pathname
      assert_equal output, fromgz
    end

    def test_reads_gzfile
      cf = create_cache_file "ls", "-l", "/var/spool"
      
      rm_cached_file cf
      refute_exists cf.pathname

      execlines = cf.read
      assert_exists cf.pathname

      # same as above
      cf2 = create_cache_file "ls", "-l", "/var/spool"
      
      def cf2.save_file
        fail "should not have called save file for read"
      end

      cachedlines = cf2.read
      fromgz = read_gzfile cf.pathname
      assert_equal execlines, fromgz
      assert_equal execlines, cachedlines
    end
  end
end
