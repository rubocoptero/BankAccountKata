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
    credit = Transaction::Credit.new(amount, balance)
    @transactions.unshift(credit)
  end

  def add_debit(amount, balance)
    debit = Transaction::Debit.new(amount, balance)
    @transactions.unshift(debit)
  end

  def transactions
    @transactions
  end
end

class Transaction
  class Credit
    def initialize(amount, balance)
      @balance = balance
      @amount = amount
      @date = Clock.timestamp
    end

    def credit
      @amount
    end

    def debit
      nil
    end

    def date
      @date
    end

    def balance
      @balance
    end
  end

  class Debit
    def initialize(amount, balance)
      @balance = balance
      @amount = amount
      @date = Clock.timestamp
    end

    def credit
      nil
    end

    def debit
      @amount
    end

    def date
      @date
    end

    def balance
      @balance
    end
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
    "#{transaction.date} || #{transaction.credit} || #{transaction.debit} || #{transaction.balance}"
  end
end
