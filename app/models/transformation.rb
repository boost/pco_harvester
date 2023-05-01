# frozen_string_literal: true

class Transformation < ApplicationRecord
  belongs_to :content_partner  
  belongs_to :job
 
end
