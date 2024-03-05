# frozen_string_literal: true

class TextExtractionWorker < FileExtractionWorker
  def process_extracted_documents
    Dir.children(@tmp_directory).each do |file|
      saved_file = File.read("#{@tmp_directory}/#{file}")

      saved_response = {
        'method' => 'GET',
        'status' => 200,
      }

      create_document(Yomu.read(:text, saved_file), saved_response)
      @page += 1
    end
  end

  def create_document(extracted_text, saved_response)
    page_str = format('%09d', @page)[-9..]
    name_str = @extraction_definition.name.parameterize(separator: '_')

    Extraction::Document.new(
      url: saved_response['url'], method: saved_response['method'],
      params: saved_response['params'], request_headers: saved_response['request_headers'],
      status: saved_response['status'], response_headers: saved_response['response_headers'],
      body: "{ text: #{extracted_text} }"
    ).save("#{@extraction_folder}/#{name_str}__-__#{page_str}.json")
  end
end
