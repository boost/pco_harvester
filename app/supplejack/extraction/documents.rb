module Extraction
  # Currently used for the view to generate kaminari paginations
  class Documents
    attr_reader :current_page, :per_page, :limit_value

    def initialize(folder)
      @folder = folder
      @per_page = 1
      @limit_value = -1
    end

    def [](key)
      @current_page = key&.to_i || 1
      return nil if documents_filepath[@current_page - 1].nil?

      Document.load_from_file(documents_filepath[@current_page - 1])
    end

    def total_pages
      documents_filepath.length
    end

    private

    def documents_filepath
      @documents_filepath ||= Dir.glob("#{@folder}/*.json")
    end
  end
end
