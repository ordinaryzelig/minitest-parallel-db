module Minitest

  def self.plugin_timer_init(options)
    self.reporter << TimerReporter.new(options)
  end

  class TimerReporter < AbstractReporter
    MAX_TIME_ALLOWED = 2
    def initialize(*args); end
    def start
      @start_time = Time.now
    end
    def report
      @total_time = Time.now - @start_time
      raise "Tests took too long (#{@total_time}s)" unless passed?
    end
    def passed?
      @total_time <= MAX_TIME_ALLOWED
    end
  end

end
