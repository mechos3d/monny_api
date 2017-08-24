# frozen_string_literal: true

class StRecord < ApplicationRecord
  # TODO: validate uniqueness of category + amount + time + sum (with PG index)
  validates :category, presence: true
  validates :amount, numericality: { greater_than: 0 }
end
