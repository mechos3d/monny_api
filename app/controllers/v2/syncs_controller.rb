# frozen_string_literal: true

class V2::SyncsController < ::SyncsController
  include Authorization
  before_action :authorize, only: :create

  DEFAULT_LIMIT = 50

  def create
    puts 'Testing headers .....'
    puts request.headers['Authorization']
    puts 'Testing headers END ....'
    records = sync_params[:records].map do |attributes|
      if is_a_transfer?(attributes)
        create_transfer_records(attributes)
      else
        Record.create(attributes.merge(author: english_name(attributes[:author])))
      end
    end.flatten.compact
    render json: { created: records.find_all(&:id).count,
                   updated_sums: Record.current_sums } # returns hash: { 'User1': 111, 'User2: '-222' }
  end

  protected

  def is_a_transfer?(attrs)
    attrs[:category].downcase.start_with?('transfer_')
  end

  def create_transfer_records(attrs)
    str = attrs[:category].downcase.match(/transfer_(.*)/)[1]
    user_to = english_name(str)
    user_from = english_name(attrs[:author])

    from = nil
    to = nil
    ActiveRecord::Base.transaction do
      from = Record.create(attrs.merge(sign: '-', category: 'transfer', author: user_from))
      to = Record.create(attrs.merge(sign: '+', category: 'transfer', author: user_to))
    end
    [from, to]
  end
end
