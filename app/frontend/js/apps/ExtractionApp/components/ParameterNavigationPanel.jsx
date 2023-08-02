import React from "react";

import { filter, map } from 'lodash';

import { selectParameterIds, selectAllParameters } from "~/js/features/ExtractionApp/ParametersSlice";

import { useSelector } from "react-redux";

import AddParameter from "~/js/apps/ExtractionApp/components/AddParameter";
import ParameterNavigationListItem from '~/js/apps/ExtractionApp/components/ParameterNavigationListItem';

const ParameterNavigationPanel = () => {
  const allParameters = useSelector(selectAllParameters);
  
  const queryParameters  = filter(allParameters, ['kind', 'query']);
  const headerParameters = filter(allParameters, ['kind', 'header']);
  const slugParameters   = filter(allParameters, ['kind', 'slug']);

  return(
    <div className="card field-nav-panel">
      <div className="d-flex flex-column overflow-auto">

        <div className='field-nav-panel__header'>
          <h5>Query</h5>

          <div className="btn-group card__control">
            <i className="bi bi-three-dots-vertical" data-bs-toggle='dropdown'></i>
            <ul className="dropdown-menu dropdown-menu-end">
              <li className='dropdown-item card__control-acton'>
                <i className="bi bi-eye-slash me-2"></i> Hide all query parameters
              </li>

              <li className='dropdown-item card__control-acton'>
                <i className="bi bi-eye me-2"></i> Show all query parameters
              </li>
            </ul>
          </div>
        </div>
        
        <div className='field-nav-panel__content'>

          <AddParameter buttonText='+ Add query param' kind='query' />

          <ul className="field-nav nav nav-pills flex-column overflow-auto flex-nowrap">
            {map(queryParameters, (queryParameter) => {
              return <ParameterNavigationListItem id={queryParameter.id} key={queryParameter.id} />;
            })}
          </ul>
        </div>
        
        <div className='field-nav-panel__header field-nav-panel__header--fields'>
          <h5>Header</h5>

          <div className="btn-group card__control">
            <i className="bi bi-three-dots-vertical" data-bs-toggle='dropdown'></i>
            <ul className="dropdown-menu dropdown-menu-end">
              <li className='dropdown-item card__control-acton'>
                <i className="bi bi-eye-slash me-2"></i> Hide all header parameters
              </li>

              <li className='dropdown-item card__control-acton'>
                <i className="bi bi-eye me-2"></i> Show all header parameters
              </li>
            </ul>
          </div>
        </div>
        
        <div className='field-nav-panel__content'>
          
          <AddParameter buttonText='+ Add header param' kind='header' />
          
          <ul className="field-nav nav nav-pills flex-column overflow-auto flex-nowrap">
            {map(headerParameters, (headerParameter) => {
              return <ParameterNavigationListItem id={headerParameter.id} key={headerParameter.id} />;
            })}
          </ul>
        </div>
        
        <div className='field-nav-panel__header field-nav-panel__header--fields'>
          <h5>Slug</h5>

          <div className="btn-group card__control">
            <i className="bi bi-three-dots-vertical" data-bs-toggle='dropdown'></i>
            <ul className="dropdown-menu dropdown-menu-end">
              <li className='dropdown-item card__control-acton'>
                <i className="bi bi-eye-slash me-2"></i> Hide all slug parameters
              </li>

              <li className='dropdown-item card__control-acton'>
                <i className="bi bi-eye me-2"></i> Show all slug parameters
              </li>
            </ul>
          </div>
        </div>

        
        
        <div className='field-nav-panel__content'>

          <AddParameter buttonText='+ Add slug param' kind='slug' />
          
          <ul className="field-nav nav nav-pills flex-column overflow-auto flex-nowrap">
            {map(slugParameters, (slugParameter, index) => {
              return <ParameterNavigationListItem id={slugParameter.id} key={slugParameter.id} index={index} />;
            })}
          </ul>

        </div>
        
      </div>
    </div>
  )
}

export default ParameterNavigationPanel;
