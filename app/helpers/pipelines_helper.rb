# frozen_string_literal: true

module PipelinesHelper
  def reference?(pipeline, definition)
    pipeline != definition.pipeline
  end

  def definition_help_text(definition, type)
    return "Please add a #{type} extraction" if definition.extraction_definition.blank?
    return extraction_definition_help_text(definition, type) if definition.transformation_definition.blank?
    return 'Please add fields to your transformation definition' if definition.transformation_definition.fields.empty?

    "Your #{type} is ready to run"
  end

  private

  def extraction_definition_help_text(definition, type)
    if definition.extraction_definition.extraction_jobs.any?(&:completed?)
      "Extraction sample is complete, please add your #{type} transformation"
    else
      'Extraction sample is not ready, please refresh the page to see when it is completed'
    end
  end

end
