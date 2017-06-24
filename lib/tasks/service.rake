# frozen_string_literal: true

namespace :service do
  desc 'fill date fields'
  task fill_dates: :environment do
    Record.all.each do |rec|
      if rec.amount.zero?
        puts 'DESTROYING RECORD:'
        p rec
        puts
        rec.destroy
      else
        rec.save
      end
    end
  end
end
