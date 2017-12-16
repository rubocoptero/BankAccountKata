class Transactions
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

  def transactions
    @transactions
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
