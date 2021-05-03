# frozen_string_literal: true

module Diary
  class Base < ApplicationRecord
    self.abstract_class = true
    self.table_name_prefix = 'diary.'
  end
end
