# frozen_string_literal: true

class SplitWorker
  include Sidekiq::Job

  sidekiq_options retry: 0

  def perform(extraction_job_id)
    @extraction_job = ExtractionJob.find(extraction_job_id)
    @extraction_definition = @extraction_job.extraction_definition
    @extraction_folder = @extraction_job.extraction_folder
    @tmp_directory = "#{@extraction_folder}/tmp"
    @page = 1

    setup_tmp_directory
    move_extracted_documents_into_tmp_directory
    process_extracted_documents

    FileUtils.remove_dir(@tmp_directory)

    create_transformation_jobs if @extraction_job.harvest_job.present?
  end

  private

  def create_transformation_jobs
    harvest_report = @extraction_job.harvest_job.harvest_report

    harvest_report.update(pages_extracted: 0)
    harvest_report.extraction_completed!

    (@extraction_job.extraction_definition.page..@extraction_job.documents.total_pages).each do |page|
      harvest_report.increment_pages_extracted!
      TransformationWorker.perform_async(@extraction_job.id, @extraction_job.harvest_job.id, page)
      harvest_report.increment_transformation_workers_queued!
    end
  end

  def setup_tmp_directory
    return if Dir.exist?(@tmp_directory)

    Dir.mkdir(@tmp_directory)
  end

  def move_extracted_documents_into_tmp_directory
    Dir.children(@extraction_folder).each do |file|
      next if file == 'tmp'

      FileUtils.move("#{@extraction_folder}/#{file}", "#{@tmp_directory}/#{file}")
    end
  end

  def process_extracted_documents
    Dir.children(@tmp_directory).each do |file|
      saved_response = JSON.parse(File.read("#{@tmp_directory}/#{file}"))

      Nokogiri::XML(saved_response['body']).xpath(@extraction_definition.split_selector).each_slice(100) do |records|
        create_document(records, saved_response)
        @page += 1
      end
    end
  end

  def create_document(records, saved_response)
    page_str = format('%09d', @page)[-9..]
    name_str = @extraction_definition.name.parameterize(separator: '_')

    Extraction::Document.new(
      url: saved_response['url'], method: saved_response['method'],
      params: saved_response['params'], request_headers: saved_response['request_headers'],
      status: saved_response['status'], response_headers: saved_response['response_headers'],
      body: "<?xml version=\"1.0\"?><root><records>#{records.map(&:to_xml).join}</records></root>"
    ).save("#{@extraction_folder}/#{name_str}__-__#{page_str}.json")
  end
end
