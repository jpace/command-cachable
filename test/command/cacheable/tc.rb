#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test_helper'
require 'pathname'

module Command::Cacheable
  class CommandTestCase < Test::Unit::TestCase
    CACHE_DIR = Pathname.new '/tmp/testcmdline'

    def rm_cache_dir
      CACHE_DIR.rmtree if CACHE_DIR.exist?
    end

    def setup
      super
      rm_cache_dir
    end

    def teardown
      super
      rm_cache_dir
    end

    def read_gzfile fname
      run_command "gunzip -c #{fname}"
    end

    def write_gzfile fname, content
      run_command "echo -n #{content} > #{fname}; gzip #{fname}"
    end

    def run_command cmd
      IO.popen(cmd) do |io|
        io.readlines
      end
    end
  end
end
