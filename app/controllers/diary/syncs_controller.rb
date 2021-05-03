# frozen_string_literal: true

module Diary
  class SyncsController < ApplicationController
    include Authorization
    before_action :authorize

    def create
      sync_params[:records].each do |attributes|
        Diary::Record.create(attributes)
      rescue ActiveRecord::RecordNotUnique
        # intentionally do nothing
      end
      render json: {}
    end

    private

    def sync_params
      params.require(:sync).permit(records: %i[uid text creation_time date])
    end
  end
end
