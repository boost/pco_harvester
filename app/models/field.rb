# frozen_string_literal: true

class Field < ApplicationRecord
  KINDS = %w[field reject_if delete_if].freeze

  belongs_to :transformation_definition

  enum :kind, KINDS

  def to_h
    {
      id:,
      name:,
      block:,
      kind:,
      created_at:,
      updated_at:
    }
  end
end
