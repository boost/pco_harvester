import React from "react";
import { createPortal } from "react-dom";
import { useDispatch, useSelector } from "react-redux";
import {
  clickedOnRunFields,
  selectAppDetails,
} from "/js/features/AppDetailsSlice";
import { selectFieldIds } from "/js/features/FieldsSlice";

const HeaderActions = () => {
  const dispatch = useDispatch();
  const fieldIds = useSelector(selectFieldIds);
  const appDetails = useSelector(selectAppDetails);

  const runAllFields = () => {
    dispatch(
      clickedOnRunFields({
        contentSourceId: appDetails.contentSource.id,
        transformationDefinitionId: appDetails.transformationDefinition.id,
        record: appDetails.rawRecord,
        fields: fieldIds,
      })
    );
  };

  return createPortal(
    <button className="btn btn-success" onClick={() => runAllFields()}>
      <i className="bi bi-play" aria-hidden="true"></i> Run All
    </button>,
    document.getElementById("react-header-actions")
  );
};

export default HeaderActions;
