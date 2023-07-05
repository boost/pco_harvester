import React from "react";
import { useSelector } from "react-redux";
import { selectAppDetails } from "/js/features/AppDetailsSlice";
import { selectUiAppDetails } from "/js/features/UiAppDetailsSlice";
import ExpandCollapseIcon from "./components/ExpandCollapseIcon";
import RecordViewer from "~/js/apps/TransformationApp/components/RecordViewer";
import JumpTo from "./JumpTo";

const RawDataBody = ({ clickToggleSection }) => {
  const { rawRecord, format } = useSelector(selectAppDetails);
  const { rawRecordExpanded } = useSelector(selectUiAppDetails);

  return (
    <>
      <div className="d-flex flex-row flex-nowrap justify-content-between mb-4">
        <h5 className="text-truncate">Raw data</h5>

        <div class="hstack gap-2">
          <JumpTo />
          <button
            onClick={() => clickToggleSection("rawRecordExpanded")}
            type="button"
            className="btn btn-primary"
          >
            <ExpandCollapseIcon expanded={rawRecordExpanded} />
          </button>
        </div>
      </div>

      <RecordViewer record={rawRecord} format={format} />
    </>
  );
};

export default RawDataBody;
