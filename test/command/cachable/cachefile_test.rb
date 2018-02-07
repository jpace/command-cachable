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
    
    def test_read_file_missing
      cf = create_cache_file "ls", "/var/spool"
      
      rm_cached_file cf
      refute_exists cf.pathname
      
      output = cf.read
      assert_false output
    end
    
    def test_read_file_exists
      cf = create_cache_file "ls", "/var/spool"
      
      rm_cached_file cf
      refute_exists cf.pathname

      dir = cf.pathname.parent
      dir.mkpath unless dir.exist?

      rootname = dir + cf.pathname.basename(".gz")

      write_gzfile rootname, %w{ abc }
      cf.save %w{ abc }
      
      assert_equal [ "abc\n" ], cf.read
    end
  end
end
