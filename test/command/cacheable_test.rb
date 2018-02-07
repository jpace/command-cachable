require "test_helper"

class Command::CacheableTest < Test::Unit::TestCase
  def test_that_it_has_a_version_number
    refute_nil ::Command::Cacheable::VERSION
  end

  def test_init
    assert true
  end
end
