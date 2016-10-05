class Record < ApplicationRecord
  def self.current_sum
    amounts = Record.group(:sign).sum(:amount)
    (amounts['+'] || 0) - (amounts['-'] || 0)
  end
end
