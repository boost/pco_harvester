# frozen_string_literal: true

class Request < ApplicationRecord
  belongs_to :extraction_definition
  has_many   :parameters

  validates :method, presence: true
end
