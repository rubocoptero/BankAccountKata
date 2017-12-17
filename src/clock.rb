require 'date'

class Clock
  DATE_FORMAT = '%d/%m/%Y'

  class << self
    def timestamp
      format(now)
    end

    private

    def now
      Date.today
    end

    def format(date)
      date.strftime(DATE_FORMAT)
    end
  end
end
