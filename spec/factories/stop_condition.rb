# frozen_string_literal: true

FactoryBot.define do
  factory :stop_condition do
    name { 'Name' }
    block  { 'response.status == 200' }
  end
end
