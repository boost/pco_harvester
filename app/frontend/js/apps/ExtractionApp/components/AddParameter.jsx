
import React from "react";
import { useDispatch, useSelector } from "react-redux";
import { addParameter, hasEmptyParameters } from "~/js/features/ExtractionApp/ParametersSlice";
import { selectAppDetails } from "~/js/features/ExtractionApp/AppDetailsSlice";

const AddParameter = ({ kind, buttonText }) => {
  const dispatch = useDispatch();
  const appDetails = useSelector(selectAppDetails);
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
        requestId: appDetails.request.id
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
        { buttonText }
      </button>
    </div>
  );
};

export default AddParameter;
