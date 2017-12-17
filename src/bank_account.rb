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

  attr_reader :date, :balance

  def initialize(amount, balance)
    @balance = balance
    @amount = amount
    @date = Clock.timestamp
  end

  class Credit < Transaction
    def credit
      @amount
    end

    def debit
      nil
    end
  end

  class Debit < Transaction
    def credit
      nil
    end

    def debit
      @amount
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
    Statement.new(@transactions).do
  end
end

class Statement
  HEADER = 'date || credit || debit || balance'

  def initialize(transactions)
    @lines = []
    @transactions = transactions
  end

  def do
    add_header
    add_transactions
    build
  end

  private

  def add_header
    @lines << HEADER
  end

  def add_transactions
    @transactions.each do |transaction|
      @lines << statement_line_from(transaction)
    end
  end

  def statement_line_from(transaction)
    "#{transaction.date} || #{transaction.credit} || #{transaction.debit} || #{transaction.balance}"
  end

  def build
    @lines.join("\n")
  end
end
