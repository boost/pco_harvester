# frozen_string_literal: true

class Request < ApplicationRecord
  belongs_to :extraction_definition

  validates :kind, presence: true
end
