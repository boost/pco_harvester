import React, { useState } from "react";
import { createPortal } from "react-dom";
import { useDispatch, useSelector } from "react-redux";
import { map } from 'lodash';

import {
  selectUiRequestById,
} from "~/js/features/ExtractionApp/UiRequestsSlice";
import { selectRequestById, selectRequestIds, previewRequest } from "~/js/features/ExtractionApp/RequestsSlice";

import {
  selectAppDetails,
} from "~/js/features/ExtractionApp/AppDetailsSlice";

import {
  selectUiAppDetails,
} from "~/js/features/ExtractionApp/UiAppDetailsSlice";

import Modal from "react-bootstrap/Modal";
import Preview from "~/js/apps/ExtractionApp/components/Preview";

const HeaderActions = () => {
  const dispatch = useDispatch();

  const appDetails = useSelector(selectAppDetails);
  const uiAppDetails = useSelector(selectUiAppDetails);

  const requestIds       = useSelector(selectRequestIds);
  const initialRequestId = requestIds[0]
  const mainRequestId    = requestIds[1]

  const [showModal, setShowModal] = useState(false);
  const handleClose = () => setShowModal(false);
  const handleShow = () => setShowModal(true);

  const handlePreviewClick = () => {
    handleShow();
    dispatch(
      previewRequest(
        {
          harvestDefinitionId: appDetails.harvestDefinition.id,
          pipelineId: appDetails.pipeline.id,
          extractionDefinitionId: appDetails.extractionDefinition.id,
          id: initialRequestId
        }
      )
    )
  }

  return createPortal(
    <>
      <button className="btn btn-success" onClick={handlePreviewClick}>
        <i className="bi bi-play" aria-hidden="true"></i> Preview
      </button>
      
      <Modal size="lg" show={showModal} onHide={handleClose}>
        <Modal.Body>
          <div className="row">
            <div className="col-6">
              <h5>Initial Request</h5>

              <Preview id={initialRequestId} />

            </div>
          </div>
        </Modal.Body>
      </Modal>
    </>,
    document.getElementById("react-header-actions")
  );

}

export default HeaderActions;
