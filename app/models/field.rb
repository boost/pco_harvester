# frozen_string_literal: true

class Field < ApplicationRecord
  KINDS = %w[field condition].freeze
  CONDITION_KINDS = %w[reject_if delete_if].freeze

  belongs_to :transformation_definition

  enum :kind, KINDS
  enum :condition_kind, CONDITION_KINDS

  def to_h
    {
      id:,
      name:,
      block:,
      kind:
    }.merge(
        if condition?
          {
            conditionKind: condition_kind
          }
        else
          {}
        end
      )
  end
end
