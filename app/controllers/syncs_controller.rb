class SyncsController < ApplicationController

  # TODO: make number with params
  def index # currently only for testing-debugging
    @records = Record.all.limit(50)
    render json: @records.to_json
  end

  def create
    records = sync_params[:records].map do |attributes|
      Record.create(attributes)
    end
    render json: { created: records.find_all(&:id).count,
                   updated_sum: Record.current_sum }
  end

  private

  def sync_params
    params.require(:sync).permit(records: [:time, :category, :sign, :amount, :text, :author])
  end
end
