# frozen_string_literal: true

# Can be improved by using this: AbstractFactoryFactoryInterfaces
# or the iterator interface?

module Extraction
  # Currently used for the view to generate kaminari paginations
  class Documents
    attr_reader :current_page, :per_page, :limit_value

    def initialize(folder)
      @folder = folder
      @per_page = 1
      @limit_value = nil
      @documents = {}
    end

    def [](key)
      @current_page = key&.to_i || 1
      return nil unless in_bounds?(@current_page)

      @documents[@current_page] ||= Document.load_from_file(documents_filepath[@current_page - 1])
    end

    def total_pages
      documents_filepath.length
    end

    private

    def in_bounds?(current_page)
      current_page.in?(1..documents_filepath.length)
    end

    def documents_filepath
      @documents_filepath ||= Dir.glob("#{@folder}/*.json")
    end
  end
end
