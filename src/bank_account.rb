require 'date'

class Balance
  def initialize
    @balance = 0
  end

  def substract(amount)
    @balance -= amount
  end

  def add(amount)
    @balance += amount
  end

  def amount
    @balance
  end
end

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

class Transactions
  def initialize
    @transactions = []
  end

  def add_credit(amount, balance)
    @transactions.unshift({ date: Clock.timestamp, credit: amount, debit: nil, balance: balance })
  end

  def add_debit(amount, balance)
    @transactions.unshift({ date: Clock.timestamp, credit: nil, debit: amount, balance: balance })
  end

  def transactions
    @transactions
  end
end

class BankAccount
  def initialize
    @balance = Balance.new
    @transactions = Transactions.new
  end

  def deposit(amount)
    @balance.add(amount)
    @transactions.add_credit(amount, @balance.amount)
  end

  def withdrawal(amount)
    @balance.substract(amount)
    @transactions.add_debit(amount, @balance.amount)
  end

  def balance
    @balance.amount
  end

  def statement
    lines = []
    header = 'date || credit || debit || balance'

    lines << header

    lines << print_transactions

    lines.join("\n")
  end

  def print_transactions
    @transactions.transactions.map do |op|
      print(op)
    end
  end

  def print(transaction)
    "#{transaction[:date]} || #{transaction[:credit]} || #{transaction[:debit]} || #{transaction[:balance]}"
  end
end
