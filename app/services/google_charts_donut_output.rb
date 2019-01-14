# frozen_string_literal: true
class GoogleChartsDonutOutput
  attr_reader :relation, :categories
  IGNORED_CATEGORIES = ['transfer'].freeze

  # TODO: REFACTOR - not a universal service, only_expenses must be set through an argument
  def initialize(relation)
    @relation = relation.only_expenses.where.not(category: IGNORED_CATEGORIES)
  end

  def total_expenses
    relation.sum(:amount)
  end

  def perform
    relation.group(:category).sum(:amount).to_a.unshift(['Category', 'Total amount spent'])
  end

  delegate :as_json, to: :perform
end
