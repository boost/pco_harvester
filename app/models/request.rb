# frozen_string_literal: true

class Request < ApplicationRecord
  belongs_to :extraction_definition
  has_many   :parameters

  validates :http_method, presence: true

  delegate :base_url, to: :extraction_definition
  delegate :format,   to: :extraction_definition
  
  enum :http_method, { GET: 0, POST: 1 }

  def url(previous_request = nil)
    "#{base_url}/#{slug(previous_request)}"
  end

  def query_parameters(previous_request = nil)
    parameters
      .query
      .map { |parameter| parameter.evaluate(previous_request) }
      .map(&:to_h)
      .reduce(&:merge)
  end

  def headers(previous_request = nil)
    parameters
      .header
      .map { |paramater| paramater.evaluate(previous_request) }
      .map(&:to_h)
      .reduce(&:merge)
  end
  
  def to_h
    {
      id:,
      created_at:,
      updated_at:,
      http_method:,
      base_url:,
      url:,
      format:,
      preview: {
        url: nil,
        request_headers: nil,
        response_headers: nil,
        status: nil,
        body: nil
      }
    }
  end

  private
    
  def slug(previous_request)
   parameters
      .slug
      .map { |parameter| parameter.evaluate(previous_request) }
      .map(&:content)
      .join('/')
  end
end
