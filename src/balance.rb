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
