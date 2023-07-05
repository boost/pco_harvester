import React from "react";

const JumpTo = () => {
  return (
    <div className="dropdown jump-to">
      <button
        className="btn btn-primary dropdown-toggle text-truncate"
        type="button"
        data-bs-toggle="dropdown"
        data-bs-auto-close="outside"
        aria-expanded="false"
      >
        Jump to
      </button>
      <div className="dropdown-menu dropdown-menu-end jump-to__body p-2">
        <div class="row gx-1 mb-3">
          <label className="col-4 col-form-label" htmlFor="page">
            Page
          </label>
          <div className="col">
            <div className="input-group">
              <input
                name="page"
                id="page"
                className="form-control jump-to__input"
                type="number"
                value="1"
              />{" "}
              <span className="input-group-text">/ 50</span>
            </div>
          </div>
          <div className="col-auto">
            <button className="btn btn-primary">Go</button>
          </div>
        </div>
        <div class="row gx-1 mb-3">
          <label className="col-4 col-form-label" htmlFor="record">
            Record
          </label>
          <div className="col">
            <div className="mr-2">
              <div className="input-group">
                <input
                  name="record"
                  id="record"
                  className="form-control jump-to__input"
                  type="number"
                  value="1"
                />
                <span className="input-group-text"> / 50</span>
              </div>
            </div>
          </div>
          <div className="col-auto">
            <button className="btn btn-primary">Go</button>
          </div>
        </div>
        <div
          className="btn-group-vertical w-100"
          role="group"
          aria-label="Quick navigation"
        >
          <button className="btn btn-outline-primary">Previous</button>
          <button className="btn btn-outline-primary">Next</button>
        </div>
      </div>
    </div>
  );
};

export default JumpTo;
