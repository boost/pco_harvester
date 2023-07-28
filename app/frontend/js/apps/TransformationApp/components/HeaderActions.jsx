import React from "react";
import { createPortal } from "react-dom";
import { useDispatch, useSelector } from "react-redux";
import {
  clickedOnRunFields,
  selectAppDetails,
} from "/js/features/AppDetailsSlice";
import { selectFieldIds } from "/js/features/FieldsSlice";
import { selectUiAppDetails } from "~/js/features/UiAppDetailsSlice";
import { selectRawRecord } from "/js/features/RawRecordSlice";

const HeaderActions = () => {
  const dispatch = useDispatch();
  const fieldIds = useSelector(selectFieldIds);
  const appDetails = useSelector(selectAppDetails);
  const rawRecord = useSelector(selectRawRecord);

  const runAllFields = () => {
    dispatch(
      clickedOnRunFields({
        harvestDefinitionId: appDetails.harvestDefinition.id,
        pipelineId: appDetails.pipeline.id,
        transformationDefinitionId: appDetails.transformationDefinition.id,
        page: rawRecord.page,
        record: rawRecord.record,
        fields: fieldIds,
      })
    );
  };

  return createPortal(
    <>
      <button className="btn btn-success" onClick={runAllFields}>
        <i className="bi bi-play" aria-hidden="true"></i> Preview
      </button>
    </>,
    document.getElementById("react-header-actions")
  );
};

export default HeaderActions;
