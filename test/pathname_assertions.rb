#!/usr/bin/ruby -w
# -*- ruby -*-

require 'pathname'

module PathnameAssertions
  def refute_exists pn
    pn = pn.kind_of?(Pathname) ? pn : Pathname.new(pn)
    assert_false pn.exist?, "pn: #{pn}"
  end
 
  def assert_exists pn
    pn = pn.kind_of?(Pathname) ? pn : Pathname.new(pn)
    assert_true pn.exist?, "pn: #{pn}"
  end
end
