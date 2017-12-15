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
end

describe BankAccount do
  it 'prints a bank statement' do
    bank_account = BankAccount.new

    bank_account.deposit(1000)
    bank_account.deposit(2000)
    bank_account.withdrawal(500)

    expect(bank_account.balance).to eq(2500)
  end
end
