import React from "react";
import { useDispatch, useSelector } from "react-redux";
import {
  addParameter,
  hasEmptyParameters,
} from "~/js/features/ExtractionApp/ParametersSlice";
import { selectAppDetails } from "~/js/features/ExtractionApp/AppDetailsSlice";
import { selectUiAppDetails } from "~/js/features/ExtractionApp/UiAppDetailsSlice";
import Tooltip from "~/js/components/Tooltip";

const AddParameter = ({ kind, buttonText }) => {
  const dispatch = useDispatch();
  const appDetails = useSelector(selectAppDetails);
  const uiAppDetails = useSelector(selectUiAppDetails);
  const emptyParameters = useSelector(hasEmptyParameters);

  const addNewParameter = () => {
    dispatch(
      addParameter({
        name: "",
        content: "",
        kind: kind,
        harvestDefinitionId: appDetails.harvestDefinition.id,
        pipelineId: appDetails.pipeline.id,
        extractionDefinitionId: appDetails.extractionDefinition.id,
        requestId: uiAppDetails.activeRequest,
      })
    );
  };

  return (
    <>
      {emptyParameters && (
        <Tooltip data-bs-title="Please save incomplete parameters before adding another">
          <div className="d-grid gap-2">
            <button disabled="true" className="btn btn-outline-primary">
              {buttonText}
            </button>
          </div>
        </Tooltip>
      )}

      {!emptyParameters && (
        <div className="d-grid gap-2">
          <button
            className="btn btn-outline-primary"
            onClick={() => addNewParameter()}
          >
            {buttonText}
          </button>
        </div>
      )}
    </>
  );
};

export default AddParameter;
