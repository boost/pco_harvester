# frozen_string_literal: true

class RawRecordSlice
  def initialize(transformation_definition, page, record)
    @page = (page || 1).to_i
    @record = (record || 1).to_i

    @job = transformation_definition.extraction_job
    @records = transformation_definition.records(@page)
  end

  def call
    {
      page: @page,
      record: @record,
      totalPages: total_pages,
      totalRecords: @records.length,
      format:,
      body: @records[@record - 1]
    }
  end

  private

  def total_pages
    return 0 if @job.blank?

    @job.documents.total_pages
  end

  def format
    return 'JSON' if @job.blank?

    @job.format
  end
end
