class Record < ApplicationRecord
  validates :time, uniqueness: true
  validates :amount, numericality: { greater_than: 0 }

  before_save :truncate_date_value

  def self.total_sum
    current_sum
  end

  def self.current_sum
    amounts = Record.group(:sign).sum(:amount)
    (amounts['+'] || 0) - (amounts['-'] || 0)
  end

  private

  # NOTE: date field is needed to sort records by date
  # (can use PG date_trunc, but just saving this data in DB makes it much easier to work with)
  def truncate_date_value
    self.date = time.change(hour: 0)
  end
end
