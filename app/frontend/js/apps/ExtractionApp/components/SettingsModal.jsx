import React, { useState} from "react";
import { createPortal } from "react-dom";
import { useSelector, useDispatch } from "react-redux";
import { selectAppDetails } from "~/js/features/ExtractionApp/AppDetailsSlice";
import Tooltip from "~/js/components/Tooltip";

import { updateExtractionDefinition } from '~/js/features/ExtractionApp/AppDetailsSlice';

import Modal from "react-bootstrap/Modal";

const SettingsModal = ({
  showModal,
  handleClose
}) => {
  const appDetails = useSelector(selectAppDetails);

  const { id, base_url, total_selector, per_page, throttle } = appDetails.extractionDefinition;
  let paginated;

  if(appDetails.extractionDefinition.paginated == null) {
    paginated = appDetails.extractionDefinition.paginated = true;
  } else {
    paginated = appDetails.extractionDefinition.paginated
  }

  const format    = appDetails.extractionDefinition.format || 'JSON';

  const dispatch = useDispatch();

  const [baseUrlValue, setBaseUrlValue] = useState(base_url);
  const [formatValue, setFormatValue] = useState(format);
  const [totalSelectorValue, setTotalSelectorValue] = useState(total_selector);
  const [perPageValue, setPerPageValue] = useState(per_page);
  const [throttleValue, setThrottleValue] = useState(throttle);
  const [paginatedValue, setPaginatedValue] = useState(paginated);

  const handleUpdateClick = async () => {
    await dispatch(
      updateExtractionDefinition({
        id: id,
        pipeline_id: appDetails.pipeline.id,
        harvest_definition_id: appDetails.harvestDefinition.id,
        base_url: baseUrlValue,
        format: formatValue,
        total_selector: totalSelectorValue,
        per_page: perPageValue,
        throttle: throttleValue || 0,
        paginated: paginatedValue
      })
    );

    handleClose();
  };

  return createPortal(
    <Modal
      size="lg"
      show={showModal}
      onHide={handleClose}
      className="modal"
    >
      <Modal.Header closeButton>
        <Modal.Title>Extraction Definition Settings</Modal.Title>
      </Modal.Header>
      <Modal.Body>

        <div className='row gy-3 align-items-center'>
          <div className="col-3">
            <strong>Base URL </strong>
            <Tooltip data-bs-title="Placeholder">
              <i
                className="bi bi-question-circle"
                aria-label="help text"
              ></i>
            </Tooltip>
          </div>
          <div className='col-9'>
            <input
              id="base_url"
              type="text"
              defaultValue={base_url}
              className="form-control"
              required="required"
              onChange={(e) => setBaseUrlValue(e.target.value)}
            />
          </div>

          <div className="col-3">
            <strong>Format </strong>
            <Tooltip data-bs-title="Placeholder">
              <i
                className="bi bi-question-circle"
                aria-label="help text"
              ></i>
            </Tooltip>
          </div>
          <div className='col-9'>
          <select
            className="form-select"
            aria-label="Format"
            defaultValue={format}
            onChange={(e) => setFormatValue(e.target.value)}
          >
            <option value="JSON">JSON</option>
            <option value="XML">XML</option>
            <option value="HTML">HTML</option>
            <option value="OAI">OAI</option>
          </select>
          </div>

          <div className="col-3">
            <strong>Throttle </strong>
            <Tooltip data-bs-title="Placeholder">
              <i
                className="bi bi-question-circle"
                aria-label="help text"
              ></i>
            </Tooltip>
          </div>
          <div className='col-9'>
            <input
              id="throttle"
              type="number"
              className="form-control"
              required="required"
              defaultValue={throttle}
              onChange={(e) => setThrottleValue(e.target.value)}
            />
          </div>

          <div className="col-3">
            <strong>Total Selector </strong>
            <Tooltip data-bs-title="Placeholder">
              <i
                className="bi bi-question-circle"
                aria-label="help text"
              ></i>
            </Tooltip>
          </div>
          <div className='col-9'>
            <input
              id="total_selector"
              type="text"
              className="form-control"
              required="required"
              defaultValue={total_selector}
              onChange={(e) => setTotalSelectorValue(e.target.value)}
            />
          </div>

          <div className="col-3">
            <strong>Per page </strong>
            <Tooltip data-bs-title="Placeholder">
              <i
                className="bi bi-question-circle"
                aria-label="help text"
              ></i>
            </Tooltip>
          </div>
          <div className='col-9'>
            <input
              id="per_page"
              type="text"
              className="form-control"
              required="required"
              defaultValue={per_page}
              onChange={(e) => setPerPageValue(e.target.value)}
            />
          </div>

          <div className="col-3">
            <strong>Pagination </strong>
            <Tooltip data-bs-title="Placeholder">
              <i
                className="bi bi-question-circle"
                aria-label="help text"
              ></i>
            </Tooltip>
          </div>
          <div className='col-9'>
            <select
              className="form-select"
              aria-label="Pagination"
              defaultValue={paginated}
              onChange={(e) => setPaginatedValue(e.target.value)}
            >
              <option value="true">Required</option>
              <option value="false">Not Required</option>
            </select>
          </div>
        </div>
        
        <div className='float-end mt-4'>
          {/* <a className='btn btn-outline-danger me-2' >Cancel</a> */}
          <button className='btn btn-outline-danger me-2' onClick={handleClose}>Cancel</button>

          <button className="btn btn-success" onClick={handleUpdateClick}>
            Update Harvest Extraction
          </button>
        </div>
      </Modal.Body>
    </Modal>,
    document.getElementById("react-modals")
  );
};

export default SettingsModal;
