# frozen_string_literal: true

module PipelinesHelper
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

  def autocomplete_harvest_extraction_definitions
    ExtractionDefinition.all.harvest.sort_by(&:name).map(&:to_h).to_json
  end

  def autocomplete_harvest_transformation_definitions
    TransformationDefinition.all.harvest.sort_by(&:name).map(&:to_h).to_json
  end

  def autocomplete_enrichment_extraction_definitions
    ExtractionDefinition.all.enrichment.sort_by(&:name).map(&:to_h).to_json
  end

  def autocomplete_enrichment_transformation_definitions
    TransformationDefinition.all.enrichment.sort_by(&:name).map(&:to_h).to_json
  end
end
