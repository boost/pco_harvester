# frozen_string_literal: true

class HarvestDefinitionsController < ApplicationController
  before_action :find_pipeline
  before_action :find_harvest_definition, only: %i[update]
  before_action :find_destinations

  def create
    @harvest_definition = HarvestDefinition.new(harvest_definition_params)

    harvest_kind = @harvest_definition.kind.capitalize

    if @harvest_definition.save
      redirect_to pipeline_path(@pipeline), notice: "#{harvest_kind} created successfully"
    else
      flash.alert = "There was an issue creating your #{harvest_kind}"

      @enrichment_definition = HarvestDefinition.new(pipeline: @pipeline)

      render 'pipelines/show'
    end
  end

  def update
    respond_to do |format|
      format.html do
        if @harvest_definition.update(harvest_definition_params)
          flash.notice = 'Harvest definition update successfully'
        else
          flash.alert = 'There was an issue updating your Harvest Definition'
        end

        redirect_to pipeline_path(@pipeline)
      end
      format.json do
        if @harvest_definition.update(harvest_definition_params)
          render status: :ok, json: 'Harvest Definition update successfully'
        else
          render status: :internal_server_error, json: 'There was an issue updating your Harvest Definition'
        end
      end
    end
  end

  def destroy
    if @harvest_definition.destroy
      flash.notice = 'Harvest Definition deleted successfully'
    else
      flash.alert = 'There was an issue deleting your Harvest Definition'
    end

    redirect_to pipeline_path(@pipeline)
  end

  private

  def find_pipeline
    @pipeline = Pipeline.find(params[:pipeline_id])
  end

  def find_destinations
    @destinations = Destination.all
  end

  def find_harvest_definition
    @harvest_definition = HarvestDefinition.find(params[:id])
  end

  def harvest_definition_params
    params.require(:harvest_definition).permit(
      :pipeline_id,
      :extraction_definition_id,
      :job_id,
      :transformation_definition_id,
      :destination_id,
      :source_id,
      :priority,
      :kind,
      :required_for_active_record,
      :name
    )
  end
end
