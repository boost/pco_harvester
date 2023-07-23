import React from "react";
import { useDispatch, useSelector } from "react-redux";
import { addField, hasEmptyFields } from "~/js/features/FieldsSlice";
import { selectAppDetails } from "~/js/features/AppDetailsSlice";

const AddField = () => {
  const dispatch = useDispatch();
  const appDetails = useSelector(selectAppDetails);
  const emptyFields = useSelector(hasEmptyFields);

  const addNewField = () => {
    dispatch(
      addField({
        name: "",
        block: "",
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
        + Add field
      </button>
    </div>
  );
};

export default AddField;
