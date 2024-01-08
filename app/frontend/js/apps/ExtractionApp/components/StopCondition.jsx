import React, { useState } from "react";
import { useSelector, useDispatch } from "react-redux";
import classNames from "classnames";

import Button from "react-bootstrap/Button";
import Modal from "react-bootstrap/Modal";

import {
  updateStopCondition,
  deleteStopCondition,
} from "~/js/features/ExtractionApp/StopConditionsSlice";

import { selectStopConditionById } from "~/js/features/ExtractionApp/StopConditionsSlice";
import {
  selectAppDetails,
} from "~/js/features/TransformationApp/AppDetailsSlice";
import {
  toggleDisplayStopCondition,
  setActiveStopCondition,
} from "~/js/features/ExtractionApp/UiStopConditionsSlice";

import { selectUiStopConditionById } from "~/js/features/ExtractionApp/UiStopConditionsSlice";
import CodeEditor from "~/js/components/CodeEditor";

const StopCondition = ({ id }) => {
  const appDetails = useSelector(selectAppDetails);
  const { name, content } = useSelector((state) =>
    selectStopConditionById(state, id)
  );

  const { saved, deleting, saving, displayed, active } =
    useSelector((state) => selectUiStopConditionById(state, id));

  const dispatch = useDispatch();

  const [nameValue, setNameValue] = useState(name);
  const [contentValue, setContentValue] = useState(content);
  const [showModal, setShowModal] = useState(false);


  const handleHideClick = () => {
    dispatch(toggleDisplayStopCondition({ id: id, displayed: false }));
  };

  const handleSaveClick = () => {
    dispatch(
      updateStopCondition({
        id: id,
        name: nameValue,
        content: contentValue,
        harvestDefinitionId: appDetails.harvestDefinition.id,
        pipelineId: appDetails.pipeline.id,
        extractionDefinitionId: appDetails.extractionDefinition.id,
      })
    );
  };

  const handleDeleteClick = () => {
    dispatch(
      deleteStopCondition({
        id: id,
        harvestDefinitionId: appDetails.harvestDefinition.id,
        pipelineId: appDetails.pipeline.id,
        extractionDefinitionId: appDetails.extractionDefinition.id,
      })
    );
    handleClose();
  };

  const isValid = () => {
    return nameValue.trim() !== "" && contentValue.trim() !== "";
  };

  const hasChanged = () => {
    return name !== nameValue || content !== contentValue;
  };

  const isSaveable = () => {
    return isValid() && hasChanged() && !saving;
  };

  const badgeClasses = classNames({
    badge: true,
    "ms-2": true,
    "bg-primary": saved,
    "bg-secondary": hasChanged(),
  });

  const badgeText = () => {
    if (hasChanged()) {
      return "unsaved";
    } else if (saved) {
      return "saved";
    }
  };

  const stopConditionClasses = classNames("col-12", "collapse", 'mt-4', {
    show: displayed,
    "border-primary": active,
  });

  const cardClasses = classNames("card", "border", "rounded", {
    "border-primary": active,
  });

  const handleClose = () => setShowModal(false);
  const handleShow = () => setShowModal(true);

  return (
    <>
      <div
        id={`stop-condition-${id}`}
        className={stopConditionClasses}
        data-testid="stop-condition"
        onClick={() => dispatch(setActiveStopCondition(id))}
      >
        <div className={cardClasses}>
          <div className="card-body">
            <div className="d-flex d-row justify-content-between align-items-center">
              <div>
                <h5 className="m-0 d-inline">{name}</h5>
                <span className={badgeClasses}>{badgeText()}</span>
              </div>

              <div className="hstack gap-2">
                <button
                  className="btn btn-outline-primary"
                  disabled={!isSaveable()}
                  onClick={handleSaveClick}
                >
                  <i className="bi bi-save" aria-hidden="true"></i>
                  {saving ? " Saving..." : " Save"}
                </button>

                <button
                  className="btn btn-outline-primary"
                  onClick={handleHideClick}
                >
                  <i className="bi bi-eye-slash" aria-hidden="true"></i> Hide
                </button>

                <button className="btn btn-outline-danger" onClick={handleShow}>
                  <i className="bi bi-trash" aria-hidden="true"></i>
                  {deleting ? " Deleting..." : " Delete"}
                </button>
              </div>
            </div>

            <div className="mt-3 show" id={`stop-condition-${id}-content`}>
              <div className="row">
                <div className="col-12">
                  <div className="row">
                    <label className="col-form-label col-sm-2" htmlFor="name">
                      <strong>Name </strong>
                    </label>

                    <div className="col-sm-10">
                      <input
                        id="name"
                        type="text"
                        className="form-control"
                        required="required"
                        defaultValue={name}
                        onChange={(e) => setNameValue(e.target.value)}
                      />
                    </div>
                  </div>
                </div>
              </div>

              <label className="form-label mt-4" htmlFor="content">
                Content{" "}
              </label>

              <CodeEditor
                initContent={content}
                onChange={(e) => setContentValue(e.target.value)}
              />
            </div>
          </div>
        </div>
      </div>

      <Modal show={showModal} onHide={handleClose}>
        <Modal.Header closeButton>
          <Modal.Title>Delete</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          Are you sure you want to delete the stop condition "{name}"?
        </Modal.Body>
        <Modal.Footer>
          <Button variant="secondary" onClick={handleClose}>
            Close
          </Button>
          <Button variant="danger" onClick={handleDeleteClick}>
            Delete
          </Button>
        </Modal.Footer>
      </Modal>
    </>
  );
};

export default StopCondition;
