# frozen_string_literal: true

class LoadJob < ApplicationRecord
  include Job

  belongs_to :harvest_job
  delegate :harvest_definition, to: :harvest_job
  
  after_create do
    self.name = "#{harvest_definition.name}__#{self.class.to_s.underscore.dasherize}__#{self.id}"
    save!
  end
end
