# frozen_string_literal: true

require 'securerandom'

namespace :s3 do
  task extract: :environment do
    acts_harvest = HarvestDefinition.find_by(source_id: 'lenz_acts')
    bills_harvest = HarvestDefinition.find_by(source_id: 'lenz_bills')
    deemed_regulations_harvest = HarvestDefinition.find_by(source_id: 'lenz_deemed_regulations')
    regulations_harvest = HarvestDefinition.find_by(source_id: 'lenz_regulations')
    sops_harvest = HarvestDefinition.find_by(source_id: 'lenz_sops')

    p 'Starting S3 sync...'

    p 'Extracting Acts...'
    S3ExtractionExecution.new(acts_harvest.extraction_definition.id, 's3://lenz-data/10042024/Acts', '*-document-metadata.xml').call

    p 'Extracting Bills...'
    S3ExtractionExecution.new(bills_harvest.extraction_definition.id, 's3://lenz-data/10042024/Bills', '*-document-metadata.xml').call

    p 'Extracting Deemed regulations...'
    S3ExtractionExecution.new(deemed_regulations_harvest.extraction_definition.id, 's3://lenz-data/10042024/Deemed Regulations', '*-document-metadata.xml').call

    p 'Extracting Regulations...'
    S3ExtractionExecution.new(regulations_harvest.extraction_definition.id, 's3://lenz-data/10042024/Regulations', '*-document-metadata.xml').call

    p 'Extracting Sops...'
    S3ExtractionExecution.new(sops_harvest.extraction_definition.id, 's3://lenz-data/10042024/Sops', '*-document-metadata.xml').call

    p 'Completed!'
  end
end

class S3ExtractionExecution
  def initialize(extraction_definition_id, source, file_pattern)
    @extraction_definition = ExtractionDefinition.find(extraction_definition_id)
    @source = source
    @file_pattern = file_pattern
    @extraction_job = ExtractionJob.create(extraction_definition: @extraction_definition)
  end

  def call
    initialize_folder_structure
    sync_files
    convert_files_to_extraction_job
    p 'Complete!'
  end

  private

  def initialize_folder_structure
    p 'Initializing folder structure...'

    @directory_path = "./extractions/#{Rails.env}/s3"
    @job_id = SecureRandom.hex

    FileUtils.mkdir_p("#{@directory_path}/#{@job_id}")
  end

  def sync_files
    p 'Syncing files from S3...'

    `aws s3 sync '#{@source}' '#{@directory_path}/#{@job_id}' --exclude '*' --include '#{@file_pattern}'`
  end

  def convert_files_to_extraction_job
    p 'Converting files from S3 into extraction job format...'

    page = 1

    Dir["#{@directory_path}/#{@job_id}/**/*.xml"].each do |file|
      page_str = format('%09d', page)[-9..]
      name_str = @extraction_definition.name.parameterize(separator: '_')

      Extraction::Document.new(
        url: 's3', method: 's3 cli',
        params: '', request_headers: [],
        status: '', response_headers: [],
        body: File.read(file)
      ).save("#{@extraction_job.extraction_folder}/#{name_str}__-__#{page_str}.json")

      page += 1
    end

    @extraction_job.completed!
  end
end