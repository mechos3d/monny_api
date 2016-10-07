class SyncsController < ApplicationController

  def index # currently only for testing-debugging
    @records = Record.all
    render json: @records.to_json
  end

  def create
    @records = sync_params[:records].map do |attributes|
      Record.create(attributes) unless duplicates.include?(attributes[:time])
    end.compact
    render json: { created: @records.size, updated_sum: Record.current_sum }
  end

  private

  def duplicates
    @duplicates ||= Record.where(time: time_params).pluck(:time)
  end

  def time_params
    sync_params[:records].map { |el| el[:time] }
  end

  def sync_params
    params.require(:sync).permit(records: [:time, :category, :sign, :amount, :text, :author])
  end
end
