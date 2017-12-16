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
  def self.timestamp
    Date.today.strftime('%d/%m/%Y')
  end
end

class BankAccount
  def initialize
    @balance = Balance.new
    @transactions = []
  end

  def deposit(amount)
    @balance.add(amount)
    @transactions.unshift({ date: Clock.timestamp, credit: amount, debit: nil, balance: @balance.amount })
  end

  def withdrawal(amount)
    @balance.substract(amount)
    @transactions.unshift({ date: Clock.timestamp, credit: nil, debit: amount, balance: @balance.amount })
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
    @transactions.map do |op|
      print(op)
    end
  end

  def print(transaction)
    "#{transaction[:date]} || #{transaction[:credit]} || #{transaction[:debit]} || #{transaction[:balance]}"
  end
end
