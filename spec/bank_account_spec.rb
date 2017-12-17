require 'rspec'
require_relative '../src/bank_account'

describe BankAccount do
  it 'prints a bank statement' do
    bank_account = BankAccount.new

    stub_clock_with('10/01/2012')
    bank_account.deposit(1000)
    stub_clock_with('13/01/2012')
    bank_account.deposit(2000)
    stub_clock_with('14/01/2012')
    bank_account.withdrawal(500)

    statement = bank_account.statement

    expect(statement).to eq(expected_statement.strip)
    expect(bank_account.balance).to eq(2500)
  end

  def expected_statement
    <<~STATEMENT
      date || credit || debit || balance
      14/01/2012 ||  || 500 || 2500
      13/01/2012 || 2000 ||  || 3000
      10/01/2012 || 1000 ||  || 1000
    STATEMENT
  end

  def stub_clock_with(value)
    allow(Clock).to receive(:timestamp).and_return(value)
  end
end
