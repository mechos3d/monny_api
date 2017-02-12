class PresentationsController < ActionController::Base
  def show
    @data_json = GoogleChartsOutput.new(filtered_relation).as_json
    @donut_data_json = GoogleChartsDonutOutput.new(filtered_relation).as_json
    render :show, layout: false
  end

  private

  # TODO: REFACTOR: move it to a query object
  def filtered_relation
    after_time = Time.parse(params[:filter][:date_from]) if params.dig(:filter, :date_from)
    before_time = Time.parse(params[:filter][:date_to]) if params.dig(:filter, :date_to)
    Record.after_time(after_time).before_time(before_time)
  end
end
