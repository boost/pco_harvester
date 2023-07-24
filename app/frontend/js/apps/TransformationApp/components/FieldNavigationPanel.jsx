import React from "react";
import { useSelector } from "react-redux";
import { selectFieldIds, selectAllFields } from "~/js/features/FieldsSlice";
import { filter } from 'lodash';
import FieldNavigationListItem from "./FieldNavigationListItem";
import AddField from "~/js/apps/TransformationApp/components/AddField";

const FieldNavigationPanel = () => {
  const allFields = useSelector(selectAllFields);

  const fields = filter(allFields, ['kind', 'field']);
  const conditions = filter(allFields, ['kind', 'condition']);

  return (
    <div className="card field-nav-panel">
      <div className="d-flex flex-column overflow-auto">
        <div className='field-nav-panel__header'>
          <h5>Conditions</h5>
        </div>

        <div className='field-nav-panel__content'>
          <AddField kind='condition' />

          <ul className="field-nav nav nav-pills flex-column overflow-auto flex-nowrap">
            {conditions.map((condition) => {
              return <FieldNavigationListItem id={condition.id} key={condition.id} />;
            })}
          </ul>
        </div>
        
        <div className='field-nav-panel__header field-nav-panel__header--fields'>
          <h5>Fields</h5>
        </div>

        <div className='field-nav-panel__content'>
          <AddField kind='field' />

          <ul className="field-nav nav nav-pills flex-column overflow-auto flex-nowrap">
            {fields.map((field) => {
              return <FieldNavigationListItem id={field.id} key={field.id} />;
            })}
          </ul>
        </div>
      </div>
    </div>
  );
};

export default FieldNavigationPanel;
