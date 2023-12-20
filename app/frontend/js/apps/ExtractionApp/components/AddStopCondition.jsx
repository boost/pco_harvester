import React from "react";
import { useDispatch, useSelector } from "react-redux";
import {
  addStopCondition,
  hasEmptyStopConditions,
} from "~/js/features/ExtractionApp/StopConditionsSlice";
import { selectAppDetails } from "~/js/features/ExtractionApp/AppDetailsSlice";
import { selectUiAppDetails } from "~/js/features/ExtractionApp/UiAppDetailsSlice";
import Tooltip from "~/js/components/Tooltip";

const AddStopCondition = ({}) => {
  const dispatch = useDispatch();
  const appDetails = useSelector(selectAppDetails);
  const uiAppDetails = useSelector(selectUiAppDetails);
  const emptyStopConditions = useSelector(hasEmptyStopConditions);

  const addNewStopCondition = () => {
    dispatch(
      addStopCondition({
        name: "",
        content: "",
        harvestDefinitionId: appDetails.harvestDefinition.id,
        pipelineId: appDetails.pipeline.id,
        extractionDefinitionId: appDetails.extractionDefinition.id,
      })
    );
  };

  return (
    <>
      {emptyStopConditions && (
        <Tooltip data-bs-title="Please save incomplete stop conditions before adding another">
          <div className="d-grid gap-2">
            <button disabled="true" className="btn btn-outline-primary">
              Add Stop Condition
            </button>
          </div>
        </Tooltip>
      )}

      {!emptyStopConditions && (
        <div className="d-grid gap-2">
          <button
            className="btn btn-outline-primary"
            onClick={() => addNewStopCondition()}
          >
            Add Stop Condition
          </button>
        </div>
      )}
    </>
  );
};

export default AddStopCondition;
