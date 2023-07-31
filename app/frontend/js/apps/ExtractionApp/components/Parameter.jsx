import React from 'react';

const Parameter = ({}) => {
  return (
    <div className="card mt-4">
      <div className="card-body">
        <div className="d-flex d-row justify-content-between align-items-center">
          <div>
            <h5 className="m-0 d-inline">Parameter!</h5>
          </div>
          
          <div className="hstack gap-2">
            <button className="btn btn-outline-primary">
              <i className="bi bi-save" aria-hidden="true"></i> Save
            </button>

            <button className="btn btn-outline-primary">
              <i className="bi bi-eye-slash" aria-hidden="true"></i> Hide
            </button>

            <button className="btn btn-outline-danger">
              <i className="bi bi-trash" aria-hidden="true"></i> Delete
            </button>
          </div>
        </div>

        <div className='row mt-3'>
          <label className="col-form-label col-sm-1" htmlFor="name">
            <strong>Key</strong>
          </label>

          <div className='col-sm-5'>
             <input type="text" className="form-control" />
          </div>

          
          <label className="col-form-label col-sm-1" htmlFor="name">
            <strong>Value</strong>
          </label>

          <div className='col-sm-5'>
             <input type="text" className="form-control" />
          </div>
        </div>
      </div>
    </div>
  )
}

export default Parameter;
