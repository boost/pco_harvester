module Extraction
  # Manages the filesystem part of the request object
  # Saves it to filesystem and loads it in memory
  class Document
    attr_reader :status, :request_headers, :response_headers, :body, :url, :method, :params

    def initialize(**kwargs)
      @url = kwargs[:url]
      @method = kwargs[:method]
      @params = kwargs[:params]
      @request_headers = kwargs[:request_headers]
      @status = kwargs[:status]
      @response_headers = kwargs[:response_headers]
      @body = kwargs[:body]
    end

    def save(file_path)
      File.write(file_path, to_json)
    end

    def self.load_from_file(file_path)
      json = JSON.parse(File.read(file_path)).symbolize_keys
      Document.new(**json)
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
