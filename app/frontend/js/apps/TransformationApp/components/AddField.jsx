import React from "react";
import { useDispatch, useSelector } from "react-redux";
import { addField, hasEmptyFields } from "~/js/features/FieldsSlice";
import {
  selectAppDetails,
} from "~/js/features/AppDetailsSlice";

const AddField = () => {
  const dispatch = useDispatch();
  const appDetails = useSelector(selectAppDetails);
  const emptyFields = useSelector(hasEmptyFields);

  const addNewField = () => {
    dispatch(
      addField({
        name: "",
        block: "",
        contentSourceId: appDetails.contentSource.id,
        transformationDefinitionId: appDetails.transformationDefinition.id,
      })
    );
  };

  return (
    <div className="d-grid gap-2 mt-4">
      <button
        disabled={emptyFields}
        className="btn btn-primary"
        onClick={() => addNewField()}
      >
        Add Field
      </button>
    </div>
  );
};

export default AddField;
