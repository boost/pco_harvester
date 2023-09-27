# frozen_string_literal: true

FactoryBot.define do
  factory :schedule do
    frequency { 0 }
    time      { '22:00' }
    harvest_definitions_to_run { [] }
  end
end
