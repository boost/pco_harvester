class ExtractionJob
  include Sidekiq::Job

  sidekiq_options retry: false

  def perform(extraction_definition_id)
    @extraction_definition = ExtractionDefinition.find(extraction_definition_id)
    ExtractionExecution.new(@extraction_definition).call
  end
end
