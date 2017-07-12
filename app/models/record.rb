# frozen_string_literal: true

# TODO: make :truncate_date_value callback before the validaion
class Record < ApplicationRecord
  validates :time, uniqueness: { scope: :author }
  validates :category, presence: true
  validates :amount, numericality: { greater_than: 0 }

  before_validation :truncate_time_value
  before_save :truncate_date_value

  scope :before_time, ->(time) { return all unless time; where('time < ?', time) }
  scope :after_time, ->(time) { return all unless time; where('time > ?', time) }
  scope :only_expenses, ->() { where(sign: '-') }
  scope :by_sign, ->(sign) { return all unless sign; where(sign: sign) }

  def self.total_sum
    current_sum
  end

  def self.current_sum # NOTE: DEPRECATED
    amounts = Record.group(:sign).sum(:amount)
    (amounts['+'] || 0) - (amounts['-'] || 0)
  end

  # NOTE: returns hash: { 'Author1': 111, 'Author2: '-222' }
  def self.current_sums
    full_hash = Record.group(:author, :sign).sum(:amount)
    result = {}
    full_hash.each do |k, v|
      author = k[0]
      sign = k[1]
      value = "#{sign}#{v}".to_i

      result[author] ||= 0
      result[author] = result[author] + value
    end

    result
  end

  private

  # NOTE: date field is needed to sort records by date
  # (can use PG date_trunc, but just saving this data in DB makes it much easier to work with)
  def truncate_date_value
    self.date = time.change(hour: 0)
  end

  def truncate_time_value
    self.time = time.round(0)
  end
end
