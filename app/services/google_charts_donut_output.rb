# frozen_string_literal: true

class GoogleChartsDonutOutput
  attr_reader :relation, :categories

  # TODO: REFACTOR - not a universal service, only_expenses must be an option or something..
  def initialize(relation)
    @relation = relation.only_expenses
  end

  def total_expenses
    relation.sum(:amount)
  end

  def perform
    relation.group(:category).sum(:amount).to_a.unshift(['Category', 'Total amount spent'])
  end

  delegate :as_json, to: :perform
end
