#!/usr/bin/ruby -w
# -*- ruby -*-

module Command::Cachable
  class Argument < String
    # just a string, but quotes itself

    def to_s
      '"' + super + '"'
    end
  end
end
