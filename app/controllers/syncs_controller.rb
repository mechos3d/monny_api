class SyncsController < ApplicationController

  def index # currently only for testing-debugging
    @records = Record.all
    render json: @records.to_json
  end

  def create
    # TODO: make it in transaction
    @records = sync_params[:records].map do |record_params|
      Record.create(record_params)
    end
    # TODO: make it return errors (especially after adding validations
    render json: { created: @records.size }
  end

  private

  # TODO: add plus-or-minus param, also add to migration
  def sync_params
    params.require(:sync).permit(records: [:time, :category, :amount, :text, :author])
  end
end
