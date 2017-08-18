# frozen_string_literal: true

class StorageRecord < ApplicationRecord
  validates :category, presence: true
  validates :amount, numericality: { greater_than: 0 }
end
