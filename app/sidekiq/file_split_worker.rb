# frozen_string_literal: true

class FileSplitWorker
  include Sidekiq::Job

  sidekiq_options retry: 0

  # ID = 148

  def perform(extraction_job_id)
    extraction_job = ExtractionJob.find(extraction_job_id)
    extraction_definition = extraction_job.extraction_definition
    extraction_folder = extraction_job.extraction_folder

    Dir.children(extraction_folder).each do |file|
      temporary_name = "#{extraction_job.name}_temp.xml"

      saved_response = JSON.parse(File.read("#{extraction_job.extraction_folder}/#{file}"))
      File.write("/tmp/#{temporary_name}", saved_response['body'])

      page = 1

      Nokogiri::XML::Reader(File.open("/tmp/#{temporary_name}")).each do |node|
        next unless node.name == 'node' && node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT

        page_str = format('%09d', page)[-9..]
        name_str = extraction_definition.name.parameterize(separator: '_')

        Extraction::Document.new(
          url: saved_response['url'],
          method: saved_response['method'],
          params: saved_response['params'],
          request_headers: saved_response['request_headers'],
          status: saved_response['status'],
          response_headers: saved_response['response_headers'],
          body: node.outer_xml
        ).save("#{extraction_folder}/#{name_str}__-__#{page_str}.json")

        page += 1
      end

      File.delete("/tmp/#{temporary_name}") 
    end
  end
end