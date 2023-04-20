module Extraction
  # Manages the filesystem part of the request object
  # Saves it to filesystem and loads it in memory
  class Document
    attr_reader :status, :request_headers, :response_headers, :body, :url, :method, :params

    def initialize(attributes)
      @url = attributes[:url]
      @method = attributes[:method]
      @params = attributes[:params]
      @request_headers = attributes[:request_headers]
      @status = attributes[:status]
      @response_headers = attributes[:response_headers]
      @body = attributes[:body]
    end

    def save(file_path)
      File.write(file_path, to_json)
    end

    def self.load_from_file(file_path)
      json = JSON.parse(File.read(file_path)).symbolize_keys
      Document.new(json)
    end

    def to_hash
      {
        url:,
        method:,
        params:,
        request_headers:,
        status:,
        response_headers:,
        body:
      }
    end

    def to_json(*args)
      JSON.generate(to_hash, *args)
    end
  end
end
