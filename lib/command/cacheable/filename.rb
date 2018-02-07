#!/usr/bin/ruby -w
# -*- ruby -*-

module Command
  module Cacheable
  end
end

module Command::Cacheable
  class FileName
    attr_reader :name

    def initialize args
      @name = args.join('-').gsub('/', '_slash_') + '.gz'
    end

    def to_s
      @name
    end
  end
end
