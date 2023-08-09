import React, { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { selectRawRecord } from "/js/features/TransformationApp/RawRecordSlice";
import {
  clickedOnRunFields,
  selectAppDetails,
} from "/js/features/TransformationApp/AppDetailsSlice";
import { selectFieldIds } from "/js/features/TransformationApp/FieldsSlice";

const JumpTo = () => {
  const dispatch = useDispatch();

  const appDetails = useSelector(selectAppDetails);

  const fieldIds = useSelector(selectFieldIds);
  const { isFetching, page, record, totalPages, totalRecords } =
    useSelector(selectRawRecord);

  const [inputPage, setInputPage] = useState(page);
  const [inputRecord, setInputRecord] = useState(record);

  useEffect(() => {
    setInputPage(page);
    setInputRecord(record);
  }, [page, record]);

  const handleSubmit = (e) => {
    e.preventDefault();
    dispatch(
      clickedOnRunFields({
        harvestDefinitionId: appDetails.harvestDefinition.id,
        pipelineId: appDetails.pipeline.id,
        transformationDefinitionId: appDetails.transformationDefinition.id,
        page: inputPage,
        record: inputRecord,
        fields: fieldIds,
      })
    );
  };

  const handleNextRecordClick = (e) => {
    dispatch(
      clickedOnRunFields({
        harvestDefinitionId: appDetails.harvestDefinition.id,
        pipelineId: appDetails.pipeline.id,
        transformationDefinitionId: appDetails.transformationDefinition.id,
        page: record === totalRecords ? page + 1 : page,
        record: record === totalRecords ? 1 : record + 1,
        fields: fieldIds,
      })
    );
  };

  const handlePreviousRecordClick = (e) => {
    dispatch(
      clickedOnRunFields({
        harvestDefinitionId: appDetails.harvestDefinition.id,
        pipelineId: appDetails.pipeline.id,
        transformationDefinitionId: appDetails.transformationDefinition.id,
        page: record === 1 ? page - 1 : page,
        record: record === 1 ? totalRecords : record - 1,
        fields: fieldIds,
      })
    );
  };

  const canClickPreviousRecord = () => isFetching || (page == 1 && record == 1);

  const canClickNextRecord = () =>
    isFetching || (page == totalPages && record == totalRecords);

  const canGoToDifferentPage = () =>
    isFetching ||
    record !== inputRecord ||
    page === inputPage ||
    inputPage > totalPages;

  const canGoToDifferentRecord = () =>
    isFetching ||
    page !== inputPage ||
    record === inputRecord ||
    inputRecord > totalRecords;

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
        <form className="row gx-1 mb-3" onSubmit={handleSubmit}>
          <label className="col-3 col-form-label" htmlFor="page">
            Page
          </label>
          <div className="col">
            <div className="input-group">
              <input
                name="page"
                id="page"
                className="form-control"
                disabled={isFetching || record !== inputRecord}
                type="number"
                value={inputPage}
                onChange={(e) => setInputPage(parseInt(e.target.value))}
              />
              <span className="input-group-text">/ {totalPages}</span>
            </div>
          </div>
          <div className="col-auto">
            <button
              className="btn btn-primary"
              disabled={canGoToDifferentPage()}
            >
              Go
            </button>
          </div>
        </form>
        <form className="row gx-1 mb-3" onSubmit={handleSubmit}>
          <label className="col-3 col-form-label" htmlFor="record">
            Record
          </label>
          <div className="col">
            <div className="mr-2">
              <div className="input-group">
                <input
                  name="record"
                  id="record"
                  className="form-control"
                  disabled={isFetching || page !== inputPage}
                  type="number"
                  value={inputRecord}
                  onChange={(e) => setInputRecord(parseInt(e.target.value))}
                />
                <span className="input-group-text"> / {totalRecords}</span>
              </div>
            </div>
          </div>
          <div className="col-auto">
            <button
              className="btn btn-primary"
              disabled={canGoToDifferentRecord()}
            >
              Go
            </button>
          </div>
        </form>
        <div
          className="btn-group-vertical w-100"
          role="group"
          aria-label="Quick navigation"
        >
          <button
            className="btn btn-outline-primary"
            disabled={canClickPreviousRecord()}
            onClick={handlePreviousRecordClick}
          >
            Previous record
          </button>
          <button
            className="btn btn-outline-primary"
            disabled={canClickNextRecord()}
            onClick={handleNextRecordClick}
          >
            Next record
          </button>
        </div>
      </div>
    </div>
  );
};

export default JumpTo;
