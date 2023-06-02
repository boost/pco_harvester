import React from "react";

import FieldNavigationList from "/js/apps/TransformationApp/components/FieldNavigationList";
import AddField from "~/js/apps/TransformationApp/components/AddField";
import ExpandCollapseIcon from "./ExpandCollapseIcon";
import { selectUiAppDetails } from "~/js/features/UiAppDetailsSlice";
import { useSelector } from "react-redux";

const FieldNavigationPanel = ({ expanded, clickToggleSection }) => {
  
  const uiAppDetails = useSelector(selectUiAppDetails);
  const { readOnly } = uiAppDetails;

  return (
    <div className="card field-nav-panel">
      <div className="card-body d-flex flex-column">
        <div className="d-flex flex-row justify-content-between align-items-center">
          <h5>Fields</h5>
        </div>

        <FieldNavigationList />
        { !readOnly && <AddField /> }
      </div>
    </div>
  );
};

export default FieldNavigationPanel;
