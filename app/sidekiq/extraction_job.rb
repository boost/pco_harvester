class ExtractionJob
  include Sidekiq::Job

  sidekiq_options retry: false

  def perform(extraction_definition_id, job_id)

    @job = Job.find(job_id)
    @job.update_attributes(status: 'running')
    
    @extraction_definition = ExtractionDefinition.find(extraction_definition_id)
   
    ExtractionExecution.new(@extraction_definition).call

    @job.update_attributes(status: 'complete')
  end
end
