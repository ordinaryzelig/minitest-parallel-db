module Minitest

  def self.plugin_timer_init(options)
    self.reporter << TimerReporter.new(options)
  end

  class TimerReporter < AbstractReporter

    # Only top-level describes
    def self.top_level_test_suites
      @top_level_test_suites ||=
        Minitest::Runnable.runnables.select do |runnable|
          [Minitest::Spec, Minitest::Unit::TestCase].include? runnable.superclass
        end
    end

    def initialize(options)
      options.fetch(:io).puts "Num test suites to time at 2s each: #{self.class.top_level_test_suites.size}."
      @max_time_allowed = 2 * self.class.top_level_test_suites.size
    end

    def start
      @start_time = Time.now
    end

    def report
      @total_time = Time.now - @start_time
      raise "Tests took too long (#{@total_time}s)" unless passed?
    end

    def passed?
      @total_time <= @max_time_allowed
    end

  end

end

Minitest.extensions << :timer
