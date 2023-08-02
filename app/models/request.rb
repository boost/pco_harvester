# frozen_string_literal: true

class Request < ApplicationRecord
  belongs_to :extraction_definition
  has_many   :parameters

  validates :http_method, presence: true

  delegate :base_url, to: :extraction_definition
  
  enum :http_method, { GET: 0, POST: 1 }

  def url
    "#{base_url}/#{slug}"
  end

  def query_parameters
    parameters
      .query
      .map(&:to_h)
      .reduce(&:merge)
  end

  def headers
    parameters
      .header
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
      url: 
    }
  end

  private
    
  def slug
   parameters
      .slug
      .map(&:content)
      .join('/')
  end
end
