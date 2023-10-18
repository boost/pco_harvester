import React from "react";
import { createPortal } from "react-dom";
import { useSelector } from "react-redux";
import classNames from "classnames";
import { selectAppDetails } from "~/js/features/ExtractionApp/AppDetailsSlice";
import { request } from "~/js/utils/request";

import Modal from "react-bootstrap/Modal";
import Preview from "~/js/apps/ExtractionApp/components/Preview";

const PreviewModal = ({
  showModal,
  handleClose,
  initialRequestId,
  mainRequestId,
}) => {
  const appDetails = useSelector(selectAppDetails);

  const initialRequestClasses = classNames({
    "col-6": appDetails.extractionDefinition.paginated,
    "col-12": !appDetails.extractionDefinition.paginated,
  });

  const handleSampleClick = async (type) => {
    const response = await request
      .post(
        `/pipelines/${appDetails.pipeline.id}/harvest_definitions/${appDetails.harvestDefinition.id}/extraction_definitions/${appDetails.extractionDefinition.id}/extraction_jobs.json?kind=sample&type=${type}`
      )
      .then((response) => {
        return response;
      });

    window.location.replace(response.data.location);
  };

  return createPortal(
    <Modal
      size="lg"
      show={showModal}
      onHide={handleClose}
      className="modal--full-width"
    >
      <Modal.Header>
        <Modal.Title>Extraction preview</Modal.Title>

        <div className="float-end">
          <button
            className="btn btn-outline-primary me-2"
            onClick={() => {
              handleClose();
            }}
          >
            <i className="bi bi-arrow-left-short" aria-hidden="true"></i>
            Continue editing extraction definition
          </button>

          <button
            className="btn btn-outline-primary me-2"
            onClick={() => {
              handleSampleClick("pipeline");
            }}
          >
            <i className="bi bi-play" aria-hidden="true"></i>
            Run sample and return to pipeline
          </button>

          <button
            className="btn btn-primary me-2"
            onClick={() => {
              handleSampleClick("transform");
            }}
          >
            <i className="bi bi-play" aria-hidden="true"></i>
            Run sample and transform data
          </button>
        </div>
      </Modal.Header>
      <Modal.Body>
        <div className="row">
          <div className={initialRequestClasses}>
            <h5>First Request</h5>

            <Preview id={initialRequestId} />
          </div>

          {appDetails.extractionDefinition.paginated && (
            <div className="col-6">
              <h5>Following Requests</h5>

              <Preview id={mainRequestId} />
            </div>
          )}
        </div>
      </Modal.Body>
    </Modal>,
    document.getElementById("react-modals")
  );
};

export default PreviewModal;
