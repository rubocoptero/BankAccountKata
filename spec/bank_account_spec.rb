require 'rspec'

class BankAccount
  
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
