require 'rspec'
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
    @operations = []
  end

  def deposit(amount)
    @balance.add(amount)
    @operations.unshift({ date: Clock.timestamp, credit: amount, debit: nil, balance: @balance.amount })
  end

  def withdrawal(amount)
    @balance.substract(amount)
    @operations.unshift({ date: Clock.timestamp, credit: nil, debit: amount, balance: @balance.amount })
  end

  def balance
    @balance.amount
  end

  def statement
    lines = []
    header = 'date || credit || debit || balance'

    lines << header

    @operations.each do |op|
      lines << "#{op[:date]} || #{op[:credit]} || #{op[:debit]} || #{op[:balance]}"
    end


    <<~STATEMENT
      date || credit || debit || balance
      14/01/2012 ||  || 500.00 || 2500.00
      13/01/2012 || 2000.00 ||  || 3000.00
      10/01/2012 || 1000.00 ||  || 1000.00
    STATEMENT

    lines.join("\n")
  end

  private

  def timestamp
    Date.today.strftime('%d/%m/%Y')
  end
end

describe BankAccount do
  it 'prints a bank statement' do
    bank_account = BankAccount.new

    stub_clock_with('10/01/2012')
    bank_account.deposit(1000)
    stub_clock_with('13/01/2012')
    bank_account.deposit(2000)
    stub_clock_with('14/01/2012')
    bank_account.withdrawal(500)

    expected_statement = <<~STATEMENT
      date || credit || debit || balance
      14/01/2012 ||  || 500 || 2500
      13/01/2012 || 2000 ||  || 3000
      10/01/2012 || 1000 ||  || 1000
    STATEMENT

    statement = bank_account.statement

    expect(statement).to eq(expected_statement.strip)
    expect(bank_account.balance).to eq(2500)
  end

  def stub_clock_with(value)
    allow(Clock).to receive(:timestamp).and_return(value)
  end
end
