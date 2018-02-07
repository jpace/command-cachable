#!/usr/bin/ruby -w
# -*- ruby -*-

require 'zlib'
require 'pathname'

module Command
end

module Command::Cacheable
  # A pathname (file) that reads and writes a list of lines, as gzipped
  class GzipPathname < Pathname
    def save_file content
      parent.mkpath unless parent.exist?
      unlink if exist?
      Zlib::GzipWriter.open(to_s) do |gz|
        gz.puts content
      end
    end

    def read_file
      content = nil
      Zlib::GzipReader.open(to_s) do |gz|
        content = gz.readlines
      end
    end
  end
end
