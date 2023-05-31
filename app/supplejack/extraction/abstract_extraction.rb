module Extraction
  class AbstractExtraction
    attr_accessor :document

    def initialize
      raise 'You cannot initialize an AbstractExtraction'
    end

    def extract
      @document = Extraction::Request.new(url:, params:, headers:).get
    end
    
    def save
      raise ArgumentError, 'extraction_folder was not provided in #new' unless @extraction_folder.present?
      raise '#extract must be called before #save AbstractExtraction' unless @document.present?

      @document.save(file_path)
    end

    def extract_and_save
      extract
      save
    end

    private

    def url
      raise 'url not defined in child class'
    end

    def params; 
      raise 'params not defined in child class'
    end

    def file_path
      raise 'file_path not defined in child class'
    end
    
    def headers
      {
        'Content-Type' => 'application/json',
        'User-Agent' => 'Supplejack Harvester v2.0'
      }
    end
  end
end
