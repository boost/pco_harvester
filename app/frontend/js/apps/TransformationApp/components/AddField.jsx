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
        contentPartnerId: appDetails.contentPartner.id,
        transformationDefinitionId: appDetails.transformationDefinition.id,
      })
    );
  };

  return (
    <div class="d-grid gap-2 mt-4">
      <button
        disabled={emptyFields}
        className="btn btn-primary me-2"
        onClick={() => addNewField()}
      >
        Add Field
      </button>
    </div>
  );
};

export default AddField;
