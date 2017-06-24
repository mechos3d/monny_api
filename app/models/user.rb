# frozen_string_literal: true

class User
  class << self
    def ru_names
      ru_hash.keys
    end

    def eng_names
      eng_hash.keys
    end

    def eng_hash
      { 'marina' => 'марина', 'pasha' => 'паша' }
    end

    def ru_hash
      { 'марина' => 'marina', 'паша' => 'pasha' }
    end
  end
end
