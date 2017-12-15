require 'rspec'

class BankAccount
  def initialize
    @balance = 0
  end

  def deposit(amount)
    @balance += amount
  end

  def withdrawal(amount)
    @balance -= amount
  end

  def balance
    @balance
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
