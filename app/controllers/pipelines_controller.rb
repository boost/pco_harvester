# frozen_string_literal: true

class PipelinesController < ApplicationController
  def index
    @sort_by = { name: :asc }
    @sort_by = { updated_at: :desc } if params['sort_by'] == 'updated_at'

    @pipelines = Pipelines.order(@sort_by).page(params[:page])
  end
end
