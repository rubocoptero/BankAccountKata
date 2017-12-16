require 'date'

class Clock
  class << self
    def timestamp
      format(now)
    end

    private

    def now
      Date.today
    end

    def format(date)
      date.strftime('%d/%m/%Y')
    end
  end
end
