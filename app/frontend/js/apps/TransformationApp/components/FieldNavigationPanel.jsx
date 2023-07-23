import React from "react";
import { useSelector } from "react-redux";
import { selectFieldIds } from "~/js/features/FieldsSlice";
import FieldNavigationListItem from "./FieldNavigationListItem";
import AddField from "~/js/apps/TransformationApp/components/AddField";

const FieldNavigationPanel = () => {
  const fieldIds = useSelector(selectFieldIds);

  return (
    <div className="card field-nav-panel">
      <div className="d-flex flex-column overflow-auto">
        <div className='field-nav-panel__header'>
          <h5>Conditions</h5>
        </div>

        <div className='field-nav-panel__content'>

        </div>
        
        <div className='field-nav-panel__header'>
          <h5>Fields</h5>
        </div>

        <div className='field-nav-panel__content'>
          <AddField />

          <ul className="field-nav nav nav-pills flex-column overflow-auto flex-nowrap">
            {fieldIds.map((id) => {
              return <FieldNavigationListItem id={id} key={id} />;
            })}
          </ul>
        </div>
      </div>
    </div>
  );
};

export default FieldNavigationPanel;
