require "test_helper"

class Command::CachableTest < Test::Unit::TestCase
  def test_that_it_has_a_version_number
    refute_nil ::Command::Cachable::VERSION
  end

  def test_init
    assert true
  end
end
