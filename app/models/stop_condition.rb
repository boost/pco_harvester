# frozen_string_literal: true

class StopCondition < ApplicationRecord
  belongs_to :extraction_definition
end
