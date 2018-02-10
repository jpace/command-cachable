#!/usr/bin/ruby -w
# -*- ruby -*-

require 'command/cacheable/gzpathname'
require 'command/cacheable/tc'
require 'tempfile'

module Command::Cacheable
  class GzipPathnameTestCase < CommandTestCase

    def test_save_file
      tempfile = Tempfile.new [ "gzippathname", ".gz" ]
      pn = GzipPathname.new tempfile.path
      if pn.exist?
        pn.unlink
      end
      assert_equal false, pn.exist?
      
      pn.save_file [ "abc" ]
      assert_equal true, pn.exist?
      content = read_gzfile pn.to_s
      begin
        assert_equal [ "abc\n" ], content
      ensure
        pn.unlink if pn.exist?
      end
    end

    def test_read_file
      tempfile = Tempfile.new "gzippathname"
      temppath = tempfile.path

      write_gzfile temppath, "def"
      
      gzpn = GzipPathname.new temppath + ".gz"
      content = gzpn.read_file
      begin
        assert_equal [ "def" ], content
      ensure
        gzpn.unlink if gzpn.exist?
      end
    end

    def test_read_file_does_not_exist
      pn = GzipPathname.new "/tmp/ahighlyunlikelyname-317"
      begin
        pn.read_file
        fail "should have been an exception"
      rescue Errno::ENOENT
        # good
      end
    end
  end
end
