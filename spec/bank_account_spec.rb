require 'rspec'

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

class BankAccount
  def initialize
    @balance = Balance.new
  end

  def deposit(amount)
    @balance.add(amount)
  end

  def withdrawal(amount)
    @balance.substract(amount)
  end

  def balance
    @balance.amount
  end

  def statement
    <<~STATEMENT
      date || credit || debit || balance
      14/01/2012 || || 500.00 || 2500.00
      13/01/2012 || 2000.00 || || 3000.00
      10/01/2012 || 1000.00 || || 1000.00
    STATEMENT
  end
end

describe BankAccount do
  it 'prints a bank statement' do
    bank_account = BankAccount.new

    bank_account.deposit(1000)
    bank_account.deposit(2000)
    bank_account.withdrawal(500)

    expected_statement = <<~STATEMENT
      date || credit || debit || balance
      14/01/2012 || || 500.00 || 2500.00
      13/01/2012 || 2000.00 || || 3000.00
      10/01/2012 || 1000.00 || || 1000.00
    STATEMENT

    statement = bank_account.statement

    expect(statement).to eq(expected_statement)
    expect(bank_account.balance).to eq(2500)
  end
end
