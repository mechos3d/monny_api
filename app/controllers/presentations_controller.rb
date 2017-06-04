class PresentationsController < ActionController::Base
  http_basic_authenticate_with name: ENV['MONNY_WEB_LOGIN'], password: ENV['MONNY_WEB_PASS']

  def show
    @data_json = GoogleChartsOutput.new(filtered_relation).as_json
    @donut_data_json = google_chart_donut_service.as_json
    @total_expenses = google_chart_donut_service.total_expenses
    render :show, layout: false
  end

  private

  # TODO: REFACTOR: rename this
  def google_chart_donut_service
    @google_chart_donut_service ||= GoogleChartsDonutOutput.new(filtered_relation)
  end

  # TODO: REFACTOR: move it to a query object
  def filtered_relation
    @fitlered_relation ||= begin
      after_time = Time.parse(params[:filter][:date_from]) if params.dig(:filter, :date_from).present?
      before_time = Time.parse(params[:filter][:date_to]) if params.dig(:filter, :date_to).present?
      Record.after_time(after_time)
            .before_time(before_time)
            .by_sign(sign_filter)
    end
  end

  def sign_filter
    if params.dig(:filter, :only_expenses)
      '-'
    elsif params.dig(:filter, :only_income)
      '+'
    end
  end
end
