import React from "react";
import { useSelector, useDispatch } from "react-redux";
import { selectFieldIds, selectAllFields } from "~/js/features/FieldsSlice";
import { filter, concat } from 'lodash';
import FieldNavigationListItem from "./FieldNavigationListItem";
import AddField from "~/js/apps/TransformationApp/components/AddField";
import {
  toggleDisplayFields
} from "~/js/features/UiFieldsSlice";

const FieldNavigationPanel = () => {
  const dispatch = useDispatch();
  const allFields = useSelector(selectAllFields);

  const fields = filter(allFields, ['kind', 'field']);
  const conditions = filter(allFields, ['kind', 'reject_if']).concat(filter(allFields, ['kind', 'delete_if']));

  return (
    <div className="card field-nav-panel">
      <div className="d-flex flex-column overflow-auto">
        <div className='field-nav-panel__header'>
          <h5>Conditions</h5>

          <div className="btn-group card__control">
            <i className="bi bi-three-dots-vertical" data-bs-toggle='dropdown'></i>
            <ul className="dropdown-menu dropdown-menu-end">
              <li className='dropdown-item card__control-acton' onClick={ () => { dispatch(toggleDisplayFields({ fields: conditions, displayed: false }))}}>
                <i className="bi bi-eye-slash me-2"></i> Hide all conditions
              </li>

              <li className='dropdown-item card__control-acton' onClick={ () => { dispatch(toggleDisplayFields({ fields: conditions, displayed: true })) }}>
                <i className="bi bi-eye me-2"></i> Show all conditions
              </li>
            </ul>
          </div>
        </div>

        <div className='field-nav-panel__content'>
          <AddField kind='reject_if' />

          <ul className="field-nav nav nav-pills flex-column overflow-auto flex-nowrap">
            {conditions.map((condition) => {
              return <FieldNavigationListItem id={condition.id} key={condition.id} />;
            })}
          </ul>
        </div>
        
        <div className='field-nav-panel__header field-nav-panel__header--fields'>
          <h5>Fields</h5>
          
          <div className="btn-group card__control">
            <i className="bi bi-three-dots-vertical" data-bs-toggle='dropdown'></i>
            <ul className="dropdown-menu dropdown-menu-end">
              <li className='dropdown-item card__control-acton' onClick={ () => { dispatch(toggleDisplayFields({ fields: fields, displayed: false }))}}>
                <i className="bi bi-eye-slash me-2"></i> Hide all fields
              </li>

              <li className='dropdown-item card__control-acton' onClick={ () => { dispatch(toggleDisplayFields({ fields: fields, displayed: true })) }}>
                <i className="bi bi-eye me-2"></i> Show all fields
              </li>
            </ul>
          </div>
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
