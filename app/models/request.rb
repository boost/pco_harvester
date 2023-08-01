# frozen_string_literal: true

class Request < ApplicationRecord
  belongs_to :extraction_definition
  has_many   :parameters

  validates :http_method, presence: true
end
