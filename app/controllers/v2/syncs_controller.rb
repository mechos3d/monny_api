# frozen_string_literal: true

class V2::SyncsController < ApplicationController
  include Authorization
  before_action :authorize
  DEFAULT_LIMIT = 50
  MAX_OFFSET = 1_000_000

  PERMITTED_FILTERS = %i(time_gt time_lt category amount_gt amount_lt text author).freeze

  def index
    @records = apply_filters
    render json: @records.to_json
  end

  def create
    records = sync_params[:records].map do |attributes|
      if is_a_transfer?(attributes)
        create_transfer_records(attributes)
      else
        Record.create(attributes)
      end
    end.flatten.compact
    render json: { created: records.find_all(&:id).count,
                   updated_sums: Record.current_sums } # returns hash: { 'User1': 111, 'User2: '-222' }
  end

  protected

  # TODO: REFACTOR: move to a query object (like in Bebop)
  # TODO: later, when there will be more Record's there will be a need to send back a gzip'ed json
  def apply_filters
    if params[:backup]
      model.all
    else
      filtered_model.non_secret.limit(limit).offset(offset)
    end
  end

  def filtered_model
    filters.inject(model) { |result, (k, v)| result.public_send("by_#{k}", v) }
  end

  def model
    Record.order(time: :desc)
  end

  def filters
    return {} unless params[:filter].present?
    @filters ||= params[:filter].select { |key, _| PERMITTED_FILTERS.include?(key.to_sym) }
  end

  def is_a_transfer?(attrs)
    attrs[:category].downcase =~ /\Atransfer__.+/
  end

  def create_transfer_records(attrs)
    match = /transfer__(.+)__(.+)\z/.match(attrs[:category])

    raise StandardError unless match.present?
    user_from, user_to = match[1], match[2]
    raise StandardError unless user_from.present? && user_to.present?

    from, to = nil, nil
    time_to = Time.zone.parse(attrs[:time]) + 1.second  # HACK: until unique index on time is changed this is needed.
    ActiveRecord::Base.transaction do
      from = Record.create(attrs.merge(sign: '-', category: 'transfer', author: user_from))
      to = Record.create(attrs.merge(sign: '+', category: 'transfer', author: user_to, time: time_to))
    end
    [from, to]
  end

  def limit
    lim = params[:limit].to_i
    lim.positive? && lim < DEFAULT_LIMIT ? lim : DEFAULT_LIMIT
  end

  def offset
    off = params[:offset].to_i
    off.positive? && off < MAX_OFFSET ? off : 0
  end

  def sync_params
    params.require(:sync).permit(records: %i[time category sign amount text author secret])
  end
end
