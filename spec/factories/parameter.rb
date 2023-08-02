# frozen_string_literal: true

FactoryBot.define do
  factory :parameter do
    name  { 'key' }
    content { 'ab.cd.ef.gh' }

    association :request
  end
end
