class Transactions
  include Enumerable

  def initialize
    @transactions = []
  end

  def add_credit(amount, balance)
    credit = Transaction.create_credit(amount, balance)
    add(credit)
  end

  def add_debit(amount, balance)
    debit = Transaction.create_debit(amount, balance)
    add(debit)
  end

  def each(&block)
    @transactions.each { |transaction| block.call(transaction) }
  end

  private

  def add(transaction)
    @transactions.unshift(transaction)
  end
end

require_relative 'clock'

class Transaction
  def self.create_credit(amount, balance)
    Transaction::Credit.new(amount, balance)
  end

  def self.create_debit(amount, balance)
    Transaction::Debit.new(amount, balance)
  end

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

require_relative 'balance'

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
    Printer.new.do(@transactions)
  end
end

class Printer
  HEADER = 'date || credit || debit || balance'

  def initialize
  end

  def do(transactions)
    lines = []

    lines << HEADER

    lines << print_statement(transactions)

    lines.join("\n")
  end

  private

  def print_statement(transactions)
    transactions.map do |transaction|
      print(transaction)
    end
  end

  def print(transaction)
    "#{transaction.date} || #{transaction.credit} || #{transaction.debit} || #{transaction.balance}"
  end
end
