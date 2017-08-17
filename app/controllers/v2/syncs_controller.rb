# frozen_string_literal: true

class V2::SyncsController < ApplicationController
  include Authorization
  before_action :authorize
  DEFAULT_LIMIT = 50
  MAX_OFFSET = 1_000_000

  def index
    @records = Record.order(time: :desc).limit(limit).offset(offset)
    render json: @records.to_json
  end

  def create
    records = sync_params[:records].map do |attributes|
      if is_a_transfer?(attributes)
        create_transfer_records(attributes)
      else
        Record.create(attributes.merge(author: User.english_name(attributes[:author])))
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
    user_to = User.english_name(str)
    user_from = User.english_name(attrs[:author])

    from = nil
    to = nil
    ActiveRecord::Base.transaction do
      from = Record.create(attrs.merge(sign: '-', category: 'transfer', author: user_from))
      to = Record.create(attrs.merge(sign: '+', category: 'transfer', author: user_to))
    end
    [from, to]
  end

  # TODO: REFACTOR: move to a query object (like in Bebop)
  def limit
    if params[:nolimit] == 'true'
      nil
    else
      lim = params[:limit].to_i
      lim.positive? && lim < DEFAULT_LIMIT ? lim : DEFAULT_LIMIT
    end
  end

  def offset
    off = params[:offset].to_i
    off.positive? && off < MAX_OFFSET ? off : 0
  end

  def sync_params
    params.require(:sync).permit(records: %i[time category sign amount text author])
  end
end
