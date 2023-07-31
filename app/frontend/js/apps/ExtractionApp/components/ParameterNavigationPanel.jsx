import React from "react";

const ParameterNavigationPanel = () => {
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
          <ul className="field-nav nav nav-pills flex-column overflow-auto flex-nowrap">
            <li className='nav-item'>
              <a className="nav-link text-truncate">
                Placeholder
              </a>
            </li>
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
          <ul className="field-nav nav nav-pills flex-column overflow-auto flex-nowrap">
            <li className='nav-item'>
              <a className="nav-link text-truncate">
                Placeholder
              </a>
            </li>
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
          <ul className="field-nav nav nav-pills flex-column overflow-auto flex-nowrap">
            <li className='nav-item'>
              <a className="nav-link text-truncate">
                Placeholder
              </a>
            </li>
          </ul>
        </div>
        
      </div>
    </div>
  )
}

export default ParameterNavigationPanel;
