import React from "react";
import { createPortal } from "react-dom";
import { useDispatch, useSelector } from "react-redux";
import {
  clickedOnRunFields,
  selectAppDetails,
} from "/js/features/AppDetailsSlice";
import { selectFieldIds } from "/js/features/FieldsSlice";
import AddField from "~/js/apps/TransformationApp/components/AddField";
import { selectUiAppDetails } from "~/js/features/UiAppDetailsSlice";

const HeaderActions = () => {
  const dispatch = useDispatch();
  const fieldIds = useSelector(selectFieldIds);
  const appDetails = useSelector(selectAppDetails);
  const { readOnly } = useSelector(selectUiAppDetails);

  const runAllFields = () => {
    dispatch(
      clickedOnRunFields({
        contentSourceId: appDetails.contentSource.id,
        format: appDetails.format,
        transformationDefinitionId: appDetails.transformationDefinition.id,
        record: appDetails.rawRecord,
        fields: fieldIds,
      })
    );
  };

  return createPortal(
    <>
      {!readOnly && <AddField />}
      <button className="btn btn-success" onClick={runAllFields}>
        <i className="bi bi-play" aria-hidden="true"></i> Run all
      </button>
    </>,
    document.getElementById("react-header-actions")
  );
};

export default HeaderActions;
