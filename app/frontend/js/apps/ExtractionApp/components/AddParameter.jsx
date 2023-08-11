import React from "react";
import { useDispatch, useSelector } from "react-redux";
import {
  addParameter,
  hasEmptyParameters,
} from "~/js/features/ExtractionApp/ParametersSlice";
import { selectAppDetails } from "~/js/features/ExtractionApp/AppDetailsSlice";
import { selectUiAppDetails } from "~/js/features/ExtractionApp/UiAppDetailsSlice";

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
    <div className="d-grid gap-2">
      <button
        disabled={emptyParameters}
        className="btn btn-outline-primary"
        onClick={() => addNewParameter()}
      >
        {buttonText}
      </button>
    </div>
  );
};

export default AddParameter;
