class Record < ApplicationRecord
  def self.current_sum
    amounts = Record.group(:sign).sum(:amount)
    amounts['+'] - amounts['-']
  end
end
