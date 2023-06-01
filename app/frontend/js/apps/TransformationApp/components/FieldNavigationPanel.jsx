import React from "react";

import FieldNavigationList from "/js/apps/TransformationApp/components/FieldNavigationList";
import AddField from "~/js/apps/TransformationApp/components/AddField";
import ExpandCollapseIcon from "./ExpandCollapseIcon";

const FieldNavigationPanel = ({
  expanded,
  runAllFields,
  clickToggleSection,
}) => {
  const expandCollapseButton = (
    <button
      onClick={() => clickToggleSection("fieldNavExpanded")}
      type="button"
      className="btn btn-primary float-end"
    >
      <ExpandCollapseIcon expanded={expanded} />
    </button>
  );

  if (!expanded) {
    return <div className="field-nav-panel">{expandCollapseButton}</div>;
  }

  return (
    <div className="card field-nav-panel">
      <div className="card-body d-flex flex-column">
        <div className="d-flex flex-row justify-content-between align-items-center">
          <h5>Fields</h5>
          {expandCollapseButton}
        </div>

        <button className="btn btn-success mt-2" onClick={() => runAllFields()}>
          Run All
        </button>

        <FieldNavigationList />
        <AddField />
      </div>
    </div>
  );
};

export default FieldNavigationPanel;
