import React from "react";
import { createPortal } from "react-dom";

import Modal from "react-bootstrap/Modal";
import Preview from "~/js/apps/ExtractionApp/components/Preview";

const EnrichmentPreviewModal = ({
  showModal,
  handleClose,
  initialRequestId,
  mainRequestId,
}) => {

  return createPortal(
    <Modal
      size="lg"
      show={showModal}
      onHide={handleClose}
      className="modal--full-width"
    >
      <Modal.Header>
        <Modal.Title>Enrichment Extraction preview</Modal.Title>

        <div className="float-end">
          <button
            className="btn btn-outline-primary me-2"
            onClick={() => {
              handleClose();
            }}
          >
            <i className="bi bi-pencil-square me-1" aria-hidden="true"></i>
            Return to edit extraction
          </button>

          <button
            className="btn btn-primary me-2"
            onClick={() => {
              handleSampleClick();
            }}
          >
            <i className="bi bi-play me-1" aria-hidden="true"></i>
            Run sample and transform data
          </button>
        </div>
      </Modal.Header>
      <Modal.Body>
        <div className="row">
          <div className="col-6">
            <h5>Record 1/500</h5>

            <Preview id={initialRequestId} view={'apiRecord'} />
          </div>

          <div className="col-6">
            <Preview id={mainRequestId} />
          </div>
        </div>
      </Modal.Body>
    </Modal>,
    document.getElementById("react-modals")
  );
};

export default EnrichmentPreviewModal;
