class GoogleChartsDonutOutput
  attr_reader :relation, :categories

  # TODO: REFACTOR - not a universal service, only_expenses must be an option or something..
  def initialize(relation)
    @relation = relation.only_expenses
  end

  def perform
    relation.group(:category).sum(:amount).to_a.unshift(['Category', 'Total amount spent'])
  end

  def as_json
    perform.as_json
  end
end
