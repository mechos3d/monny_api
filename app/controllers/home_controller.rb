class HomeController < ActionController::Base
  http_basic_authenticate_with name: ENV['MONNY_WEB_LOGIN'], password: ENV['MONNY_WEB_PASS']

  def index
    render :index, layout: false
    # @data_json = GoogleChartsOutput.new(filtered_relation).as_json
    # @donut_data_json = google_chart_donut_service.as_json
    # @total_expenses = google_chart_donut_service.total_expenses
    # render :show, layout: false
  end
end
