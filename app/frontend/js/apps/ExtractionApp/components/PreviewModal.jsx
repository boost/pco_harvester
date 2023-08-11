import React from 'react';
import { createPortal } from 'react-dom';
import { useSelector } from "react-redux";
import classNames from "classnames";
import { selectAppDetails } from "~/js/features/ExtractionApp/AppDetailsSlice";

import Modal from "react-bootstrap/Modal";
import Preview from "~/js/apps/ExtractionApp/components/Preview";

const PreviewModal = ({ showModal, handleClose, initialRequestId, mainRequestId }) => {
  const appDetails = useSelector(selectAppDetails);

  const initialRequestClasses = classNames({
    "col-6": appDetails.extractionDefinition.paginated,
    "col-12": !appDetails.extractionDefinition.paginated,
  });

  return createPortal(
    <Modal
      size="lg"
      show={showModal}
      onHide={handleClose}
      className="modal--full-width"
    >
      <Modal.Header closeButton>
        <Modal.Title>Preview</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <div className="row">
          <div className={initialRequestClasses}>
            <h5>Initial Request</h5>

            <Preview id={initialRequestId} />
          </div>

          {appDetails.extractionDefinition.paginated && (
            <div className="col-6">
              <h5>Main Request</h5>

              <Preview id={mainRequestId} />
            </div>
          )}
        </div>
      </Modal.Body>
    </Modal>,
    document.getElementById('react-modals')
  )
}

export default PreviewModal;
