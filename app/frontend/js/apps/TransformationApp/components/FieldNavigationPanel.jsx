import React from "react";

import FieldNavigationList from "/js/apps/TransformationApp/components/FieldNavigationList";
import AddField from "~/js/apps/TransformationApp/components/AddField";
import ExpandCollapseIcon from "./ExpandCollapseIcon";

const FieldNavigationPanel = ({ expanded, clickToggleSection }) => {
  return (
    <div className="card field-nav-panel">
      <div className="card-body d-flex flex-column">
        <div className="d-flex flex-row justify-content-between align-items-center">
          <h5>Fields</h5>
        </div>

        <FieldNavigationList />
      </div>
    </div>
  );
};

export default FieldNavigationPanel;
