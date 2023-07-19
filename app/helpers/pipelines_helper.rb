# frozen_string_literal: true

module PipelinesHelper
  def reference?(pipeline, definition)
    pipeline != definition.pipeline
  end

  def ready_to_run?(pipeline)
    return false if pipeline.harvest.blank?
    return false if pipeline.harvest.extraction_definition.blank?
    return false if pipeline.harvest.transformation_definition.blank?
    return false if pipeline.harvest.transformation_definition.fields.empty?

    true
  end

  def definition_help_text(definition, type)
    return "Please add a #{type} extraction" if definition.extraction_definition.blank?

    if definition.transformation_definition.blank?
      if definition.extraction_definition.extraction_jobs.any?(&:completed?)
        "Extraction sample is complete, please add your #{type} transformation"
      else
        'Extraction sample is not ready, please refresh the page to see when it is completed'
      end
    elsif definition.transformation_definition.present?
      if definition.transformation_definition.fields.empty?
        'Please add fields to your transformation definition'
      else
        "Your #{type} is ready to run"
      end
    end
  end
end
