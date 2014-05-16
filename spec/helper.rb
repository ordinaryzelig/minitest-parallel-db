require 'bundler/setup'
Bundler.require

require 'minitest/autorun'
require 'minitest/pride'

require 'minitest/parallel_db'

require_relative 'support/db_config'
require_relative 'support/timer_plugin'
