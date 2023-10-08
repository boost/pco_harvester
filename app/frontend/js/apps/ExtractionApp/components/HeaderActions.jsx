import React, { useState } from "react";
import { createPortal } from "react-dom";
import { useDispatch, useSelector } from "react-redux";
import { setLoading } from "~/js/features/ExtractionApp/UiRequestsSlice";
import { selectAppDetails } from "~/js/features/ExtractionApp/AppDetailsSlice";
import {
  selectRequestIds,
  previewRequest,
} from "~/js/features/ExtractionApp/RequestsSlice";
import PreviewModal from "~/js/apps/ExtractionApp/components/PreviewModal";
import SettingsModal from "~/js/apps/ExtractionApp/components/SettingsModal";

const HeaderActions = () => {
  const dispatch = useDispatch();
  const appDetails = useSelector(selectAppDetails);

  const requestIds = useSelector(selectRequestIds);
  const initialRequestId = requestIds[0];
  const mainRequestId = requestIds[1];

  const [showModal, setShowModal] = useState(false);
  const handleClose = () => setShowModal(false);
  const handleShow = () => setShowModal(true);

  const [showSettingsModal, setSettingsModal] = useState(false);
  const handleSettingsClose = () => setSettingsModal(false);
  const handleSettingsShow  = () => setSettingsModal(true); 

  const handlePreviewClick = async () => {
    handleShow();

    dispatch(setLoading(initialRequestId));
    dispatch(setLoading(mainRequestId));

    const initialPreview = await dispatch(
      previewRequest({
        harvestDefinitionId: appDetails.harvestDefinition.id,
        pipelineId: appDetails.pipeline.id,
        extractionDefinitionId: appDetails.extractionDefinition.id,
        id: initialRequestId,
      })
    );

    if (appDetails.extractionDefinition.paginated) {
      dispatch(
        previewRequest({
          harvestDefinitionId: appDetails.harvestDefinition.id,
          pipelineId: appDetails.pipeline.id,
          extractionDefinitionId: appDetails.extractionDefinition.id,
          id: mainRequestId,
          previousRequestId: initialPreview.payload.id,
        })
      );
    }
  };

  const handleSettingsClick = async () => {
    handleSettingsShow();
  }

  return createPortal(
    <>
      <button className="btn btn-success me-2" onClick={handlePreviewClick}>
        <i className="bi bi-play" aria-hidden="true"></i> Preview
      </button>

      <PreviewModal
        showModal={showModal}
        handleClose={handleClose}
        initialRequestId={initialRequestId}
        mainRequestId={mainRequestId}
      />

      <button className="btn btn-outline-success me-2" onClick={handleSettingsClick}>
        <i className="bi bi-sliders2" aria-hidden="true"></i> Settings
      </button>

      <SettingsModal
        showModal={showSettingsModal}
        handleClose={handleSettingsClose}
      />
    </>,
    document.getElementById("react-header-actions")
  );
};

export default HeaderActions;
