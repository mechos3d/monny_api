# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/diary/syncs', type: :request do
  let(:route) { '/diary/syncs' }
  let(:headers) do
    { Authorization: 'Bearer test_auth_token',
      'Content-Type': 'application/json' }
  end

  describe 'POST' do
    let(:record_params) do
      { uid: 'a83fe54c-ffcc-4e53-8a55-562787a2129b',
        text: 'foo bar',
        creation_time: '2021-03-22T12:25:45+03:00',
        date: '2021-03-21' }
    end

    let(:request_params) do
      { sync: { records: [ record_params ] } }.to_json
    end

    context 'simple happy path' do
      it do
        expect do
          post route, params: request_params, headers: headers
        end.to change { Diary::Record.count }.to(1)

        rec = Diary::Record.last
        aggregate_failures do
          expect(rec.uid).to eq('a83fe54c-ffcc-4e53-8a55-562787a2129b')
          expect(rec.text).to eq('foo bar')
          expect(rec.creation_time).to eq(Time.new(2021, 3, 22, 12, 25, 45, '+03:00'))
          expect(rec.date).to eq(Date.new(2021, 3, 21))
        end
      end
    end

    context 'creation of a duplicate record' do
      before do
        Diary::Record.create!(record_params)
      end

      it 'does not create a duplicate record' do
        expect do
          post route, params: request_params, headers: headers
        end.not_to change { Diary::Record.count }
      end
    end
  end
end
