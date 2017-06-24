# frozen_string_literal: true

class SyncsController < ApplicationController
  DEFAULT_LIMIT = 50

  def index
    @records = Record.order(time: :desc).limit(limit)
    render json: @records.to_json
  end

  def create
    records = sync_params[:records].map do |attributes|
      Record.create(attributes.merge(author: english_name(attributes[:author])))
    end
    render json: { created: records.find_all(&:id).count,
                   updated_sum: Record.current_sum }
  end

  protected

  def english_name(str)
    str = str.mb_chars.downcase.to_s

    return str if User.eng_names.include?(str)
    User.ru_hash[str]
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

  def sync_params
    params.require(:sync).permit(records: %i[time category sign amount text author])
  end
end
