import React, { useState } from "react";
import { useSelector } from "react-redux";
import { selectRawRecord } from "/js/features/RawRecordSlice";

const JumpTo = () => {
  const { page, record, totalPages, totalRecords } =
    useSelector(selectRawRecord);

  const [inputPage, setInputPage] = useState(page);
  const [inputRecord, setInputRecord] = useState(record);

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
        <div className="row gx-1 mb-3">
          <label className="col-4 col-form-label" htmlFor="page">
            Page
          </label>
          <div className="col">
            <div className="input-group">
              <input
                name="page"
                id="page"
                className="form-control"
                type="number"
                value={inputPage}
                onChange={(e) => setInputPage(e.target.value)}
              />
              <span className="input-group-text">/ {totalPages}</span>
            </div>
          </div>
          <div className="col-auto">
            <button
              className="btn btn-primary"
              disabled={
                record !== inputRecord ||
                page === inputPage ||
                inputPage > totalPages
              }
            >
              Go
            </button>
          </div>
        </div>
        <div className="row gx-1 mb-3">
          <label className="col-4 col-form-label" htmlFor="record">
            Record
          </label>
          <div className="col">
            <div className="mr-2">
              <div className="input-group">
                <input
                  name="record"
                  id="record"
                  className="form-control"
                  type="number"
                  value={inputRecord}
                  onChange={(e) => setInputRecord(e.target.value)}
                />
                <span className="input-group-text"> / {totalRecords}</span>
              </div>
            </div>
          </div>
          <div className="col-auto">
            <button
              className="btn btn-primary"
              disabled={
                page !== inputPage ||
                record === inputRecord ||
                inputRecord > totalRecords
              }
            >
              Go
            </button>
          </div>
        </div>
        <div
          className="btn-group-vertical w-100"
          role="group"
          aria-label="Quick navigation"
        >
          <button
            className="btn btn-outline-primary"
            disabled={page == 1 && record == 1}
          >
            Previous record
          </button>
          <button
            className="btn btn-outline-primary"
            disabled={page == totalPages && record == totalRecords}
          >
            Next record
          </button>
        </div>
      </div>
    </div>
  );
};

export default JumpTo;
