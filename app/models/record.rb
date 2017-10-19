# frozen_string_literal: true

# TODO:validate time uniqueness in scope of user
# TODO: change unique index on time to be combined time-user

# TODO: make :truncate_date_value callback before the validaion
class Record < ApplicationRecord
  validates :time, uniqueness: true
  validates :category, presence: true
  validates :amount, numericality: { greater_than: 0 }

  before_validation :truncate_time_value
  before_validation :nullify_category
  before_save :truncate_date_value

  scope :before_time, ->(time) { return all unless time; where('time < ?', time) }
  scope :after_time, ->(time) { return all unless time; where('time > ?', time) }
  scope :only_expenses, ->() { where(sign: '-') }
  scope :by_sign, ->(sign) { return all unless sign; where(sign: sign) }

  # PERMITTED_FILTERS = %w(time_gt, time_lt, category, amount_gt, amount_lt, text (ILIKE), author)
  # methods from GET-params

  class << self
    def by_time_gt(arg)
      # TODO: parse the time here
      return all unless arg
      where('time > ?', arg)
    end

    def by_time_lt(arg)
      # TODO: parse the time here
      return all unless arg
      where('time < ?', arg)
    end

    def by_category(arg)
      return all unless arg
      where(category: arg)
    end

    def by_amount_gt(arg)
      return all unless arg
      where('amount > ?', arg)
    end

    def by_amount_lt(arg)
      return all unless arg
      where('amount < ?', arg)
    end

    def by_text(arg)
      return all unless arg
      where('text ILIKE ?', arg)
    end

    def by_author(arg)
      return all unless arg
      where(author: arg)
    end
  end
  # methods from GET-params END

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

  def nullify_category
    self.category = nil if category == 'null'
  end
end
