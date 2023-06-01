import React from "react";

import NavigationPanel from "~/js/apps/TransformationApp/components/NavigationPanel";
import AddField from "~/js/apps/TransformationApp/components/AddField";

const FieldNavigation = ({
  expanded,
  expandCollapseText,
  runAllFields,
  clickToggleSection,
}) => {
  const expandCollapseButton = (
    <button
      onClick={() => clickToggleSection("fieldNavExpanded")}
      type="button"
      className="btn btn-primary float-end"
    >
      {expandCollapseText("fieldNavExpanded")}
    </button>
  );

  if (!expanded) return expandCollapseButton;

  return (
    <div className="card">
      <div className="card-body">
        <div className="clearfix">
          <h5 className="float-start">Fields</h5>
          {expandCollapseButton}
        </div>
        <button className="btn btn-success mb-4" onClick={() => runAllFields()}>
          Run All
        </button>
        <NavigationPanel />
        <AddField />
      </div>
    </div>
  );
};

export default FieldNavigation;
