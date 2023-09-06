import React from "react";
import { useDispatch, useSelector } from "react-redux";
import {
  addField,
  hasEmptyFields,
} from "~/js/features/TransformationApp/FieldsSlice";
import { selectAppDetails } from "~/js/features/TransformationApp/AppDetailsSlice";

const AddField = ({ kind }) => {
  const dispatch = useDispatch();
  const appDetails = useSelector(selectAppDetails);
  const emptyFields = useSelector(hasEmptyFields);

  const buttonText = () => {
    if (kind == "field") {
      return "field";
    }

    return "condition";
  };

  const addNewField = () => {
    dispatch(
      addField({
        name: "",
        block: "",
        kind: kind,
        harvestDefinitionId: appDetails.harvestDefinition.id,
        pipelineId: appDetails.pipeline.id,
        transformationDefinitionId: appDetails.transformationDefinition.id,
      })
    );
  };

  return (
    <div className="d-grid gap-2">
      <button
        disabled={emptyFields}
        className="btn btn-outline-primary"
        onClick={() => addNewField()}
      >
        + Add {buttonText()}
      </button>
    </div>
  );
};

export default AddField;
