class SyncsController < ApplicationController

  def index # currently only for testing-debugging
    Record.all
  end

  def create
    # TODO: make it in transaction
    records = sync_params[:records].map do |record_params|
      Record.create(record_params)
    end
    # TODO: make it return errors (especially after adding validations
    head :ok
  end

  private

  def sync_params
    params.require(:sync).permit(records: [:time, :category, :amount, :text, :author_id])
  end
end
