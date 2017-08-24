# frozen_string_literal: true

class V2::StRecordsController < ApplicationController
  include Authorization
  before_action :authorize

  # TODO: with some get-param - show only latest records from all the categories having 'non-deleted' status
  def index
    render json: StRecord.limit(100).as_json
  end

  def show
    render json: {}
  end

  def create
    StRecord.create(st_record_params)
    render json: { }
  end

  protected

  def st_record_params
    params.require(:st_record).permit(%i[amount category sign status text time unit])
  end
end
