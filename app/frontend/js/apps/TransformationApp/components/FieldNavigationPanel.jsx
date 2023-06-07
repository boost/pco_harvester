import React from "react";
import { useSelector } from "react-redux";
import { selectFieldIds } from "~/js/features/FieldsSlice";
import FieldNavigationListItem from "./FieldNavigationListItem";

const FieldNavigationPanel = () => {
  const fieldIds = useSelector(selectFieldIds);

  return (
    <div className="card field-nav-panel">
      <div className="card-body d-flex flex-column overflow-auto">
        <h5>Fields</h5>

        <ul className="field-nav nav nav-pills flex-column overflow-auto flex-nowrap">
          {fieldIds.map((id) => {
            return <FieldNavigationListItem id={id} key={id} />;
          })}
        </ul>
      </div>
    </div>
  );
};

export default FieldNavigationPanel;
