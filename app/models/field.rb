# frozen_string_literal: true

class Field < ApplicationRecord
  KINDS = %w[field condition].freeze
  CONDITION = %w[reject_if delete_if].freeze

  belongs_to :transformation_definition

  enum :kind, KINDS
  enum :condition, CONDITION

  def to_h
    {
      id:,
      name:,
      block:,
      kind:
    }.merge(
        if condition?
          {
            condition:
          }
        else
          {}
        end
      )
  end
end
