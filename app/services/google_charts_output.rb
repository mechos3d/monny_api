class GoogleChartsOutput
  attr_reader :relation, :categories

  def initialize(relation)
    @relation = relation
  end

  def perform
    @categories = relation.pluck(:category).uniq.sort
    dates = relation.order(:date).pluck(:date).uniq

    dates_hash = {}
    relation.each do |rec|
      dates_hash[rec.date] ||= {}
      amount = rec.sign == '+' ? rec.amount : - rec.amount
      current_value = dates_hash[rec.date][rec.category]

      dates_hash[rec.date][rec.category] = current_value.to_i + amount
    end

    dates.map do |date|
      categories.map do |cat|
        dates_hash[date][cat].to_i
      end.unshift(date.strftime('%F')).push(additional_option)
    end.unshift(categories_array)
  end

  def as_json
    perform.as_json
  end

  private

  def additional_option
    ''
  end

  def categories_array
    ['Category'] + categories + [{ role: 'annotation' }]
  end
end
