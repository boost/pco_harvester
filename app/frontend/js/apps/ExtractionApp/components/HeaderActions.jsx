import React, { useState } from "react";
import { createPortal } from "react-dom";
import { useDispatch, useSelector } from "react-redux";
import { map } from 'lodash';
import classNames from "classnames";

import {
  selectUiRequestById,
  setLoading,
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

  const handlePreviewClick = async () => {
    handleShow();

    dispatch(setLoading(initialRequestId))
    dispatch(setLoading(mainRequestId));

    const initialPreview = await dispatch(
      previewRequest(
        {
          harvestDefinitionId: appDetails.harvestDefinition.id,
          pipelineId: appDetails.pipeline.id,
          extractionDefinitionId: appDetails.extractionDefinition.id,
          id: initialRequestId
        }
      )
    )

    if(appDetails.extractionDefinition.paginated) {
      dispatch(
        previewRequest(
          {
            harvestDefinitionId: appDetails.harvestDefinition.id,
            pipelineId: appDetails.pipeline.id,
            extractionDefinitionId: appDetails.extractionDefinition.id,
            id: mainRequestId,
            previousRequestId: initialPreview.payload.id
          }      
        )
      )
    }
  }

  const initialRequestClasses = classNames({
    'col-6': appDetails.extractionDefinition.paginated,
    'col-12': !appDetails.extractionDefinition.paginated
  })

  return createPortal(
    <>
      <button className="btn btn-success" onClick={handlePreviewClick}>
        <i className="bi bi-play" aria-hidden="true"></i> Preview
      </button>
      
      <Modal size="lg" show={showModal} onHide={handleClose} className='modal--full-width'>
        <Modal.Body>
          <div className="row">
            <div className={ initialRequestClasses }>
              <h5>Initial Request</h5>

              <Preview id={initialRequestId} />
            </div>

            { appDetails.extractionDefinition.paginated && (
            <div className="col-6">
              <h5>Main Request</h5>
              
              <Preview id={mainRequestId} />
            </div>
            )}
          </div>
        </Modal.Body>
      </Modal>
    </>,
    document.getElementById("react-header-actions")
  );

}

export default HeaderActions;
