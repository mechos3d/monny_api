class Record < ApplicationRecord
  def self.total_sum
    current_sum
  end

  def self.current_sum
    amounts = Record.group(:sign).sum(:amount)
    (amounts['+'] || 0) - (amounts['-'] || 0)
  end
end
