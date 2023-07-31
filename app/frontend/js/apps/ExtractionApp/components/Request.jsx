import React from "react";

const Request = ({}) => {
  return(
    <div className="card">
      <div className="card-body">

        <div className="d-flex d-row justify-content-between align-items-center">
          <div>
            <h5 className="m-0 d-inline">Initial request URL</h5>
            <p>4 static, 1 header</p>
          </div>
          
          <button className="btn btn-outline-primary">
            <i className="bi bi-arrow-down-up" aria-hidden="true"></i> GET
          </button>
        </div>
        
        <div className='row mt-3'>
          <label className="col-form-label col-sm-1" htmlFor="name">
            <strong>URL</strong>
          </label>

          <div className='col-sm-11'>
             <input type="text" className="form-control" value="http://www.google.co.nz" />
          </div>
        </div>
      </div>

    </div>
  )
}

export default Request;
