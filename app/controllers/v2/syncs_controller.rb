# frozen_string_literal: true

class V2::SyncsController < ::SyncsController
  DEFAULT_LIMIT = 50

  def create
    records = sync_params[:records].map do |attributes|
      if User.ru_names.include? attributes[:category].mb_chars.downcase.to_s
        create_transfer_records(attributes)
      else
        Record.create(attributes.merge(author: english_name(attributes[:author])))
      end
    end.flatten.compact
    render json: { created: records.find_all(&:id).count,
                   updated_sums: Record.current_sums } # returns hash: { 'User1': 111, 'User2: '-222' }
  end

  protected

  def create_transfer_records(attrs)
    user_to = english_name(attrs[:category])
    user_from = english_name(attrs[:author])

    if (from = Record.create(attrs.merge(sign: '-', category: 'transfer', author: user_from)))
      to = Record.create(attrs.merge(sign: '+', category: 'transfer', author: user_to))
      [from, to]
    end
  end
end
