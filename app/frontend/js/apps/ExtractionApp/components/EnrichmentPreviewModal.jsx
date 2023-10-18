import React from "react";
import { createPortal } from "react-dom";
import { useSelector, useDispatch } from "react-redux";
import { selectAppDetails } from "~/js/features/ExtractionApp/AppDetailsSlice";

import Modal from "react-bootstrap/Modal";
import Preview from "~/js/apps/ExtractionApp/components/Preview";

import {
  previewRequest,
} from "~/js/features/ExtractionApp/RequestsSlice";

import { setLoading } from "~/js/features/ExtractionApp/UiRequestsSlice";

import {
  setCurrentPage,
  setCurrentRecord,
  selectUiAppDetails
} from "~/js/features/ExtractionApp/UiAppDetailsSlice";

const EnrichmentPreviewModal = ({
  showModal,
  handleClose,
  initialRequestId,
  mainRequestId,
}) => {

  const dispatch = useDispatch();
  const appDetails = useSelector(selectAppDetails);
  const uiAppDetails = useSelector(selectUiAppDetails);

  const handleNextRecordClick = () => {
    dispatch(setCurrentRecord(uiAppDetails.currentRecord + 1))

    requestNewPreview();
  }

  const handlePreviousRecordClick = () => {
    dispatch(setCurrentRecord(uiAppDetails.currentRecord - 1))

    requestNewPreview();
  }

  const requestNewPreview = async () => {
    dispatch(setLoading(initialRequestId));
    dispatch(setLoading(mainRequestId));

    const initialPreview = await dispatch(
      previewRequest({
        harvestDefinitionId: appDetails.harvestDefinition.id,
        pipelineId: appDetails.pipeline.id,
        extractionDefinitionId: appDetails.extractionDefinition.id,
        id: initialRequestId,
        page: uiAppDetails.currentPage,
        record: uiAppDetails.currentRecord
      })
    )

    dispatch(
      previewRequest({
        harvestDefinitionId: appDetails.harvestDefinition.id,
        pipelineId: appDetails.pipeline.id,
        extractionDefinitionId: appDetails.extractionDefinition.id,
        id: mainRequestId,
        previousRequestId: initialPreview.payload.id,
        page: uiAppDetails.currentPage,
        record: uiAppDetails.currentRecord
      })
    );
  }

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
            <h5>Record { uiAppDetails.currentRecord }/TOTAL</h5>

            <Preview id={initialRequestId} view={'apiRecord'} />
          </div>

          <div className="col-6">
            <button
              className="btn btn-outline-primary me-2"
              onClick={() => {
                handlePreviousRecordClick();
              }}
            >
              <i className="bi bi-arrow-left-short me-1" aria-hidden="true"></i>
              Previous record
            </button> 

            <button
              className="btn btn-outline-primary me-2"
              onClick={() => {
                handleNextRecordClick();
              }}
            >
              Next record
              <i className="bi bi-arrow-right-short me-1" aria-hidden="true"></i>
            </button> 

            <Preview id={mainRequestId} />
          </div>
        </div>
      </Modal.Body>
    </Modal>,
    document.getElementById("react-modals")
  );
};

export default EnrichmentPreviewModal;
