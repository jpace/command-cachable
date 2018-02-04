#!/usr/bin/ruby -w
# -*- ruby -*-

require 'command/cachable/gzpathname'
require 'command/cachable/tc'
require 'tempfile'

module Command::Cachable
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
      assert_equal [ "abc\n" ], content
    end

    def test_read_file
      tempfile = Tempfile.new "gzippathname"
      temppath = tempfile.path

      write_gzfile temppath, "def"
      
      gzpn = GzipPathname.new temppath + ".gz"
      content = gzpn.read_file
      assert_equal [ "def" ], content
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
