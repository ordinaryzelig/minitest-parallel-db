module Minitest

  def self.plugin_timer_init(options)
    self.reporter << TimerReporter.new(options)
  end

  class TimerReporter < AbstractReporter
    def initialize(options)
      test_suites = Minitest::Runnable.runnables.size - 3
      options.fetch(:io).puts "Num test suites to time at 2s each: #{test_suites}."
      @max_time_allowed = 2 * test_suites
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
