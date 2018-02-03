$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'command/cachable';
require 'test/unit'
require 'logue/log'
require 'rainbow'

# no verbose if running all tests:
level = ARGV.size == 0 ? Logue::Log::DEBUG : Logue::Log::WARN

Logue::Log.level = level
Logue::Log.set_widths(-35, 4, -35)

# produce colorized output, even when redirecting to a file:
Rainbow.enabled = true
