import React, { useState } from 'react';
import { useSelector, useDispatch } from "react-redux";
import classNames from "classnames";

import Button from "react-bootstrap/Button";
import Modal from "react-bootstrap/Modal";

import { selectParameterById, updateParameter, deleteParameter } from "~/js/features/ExtractionApp/ParametersSlice";

import {
  selectAppDetails,
} from "~/js/features/ExtractionApp/AppDetailsSlice";

import {
  selectUiParameterById,
  toggleDisplayParameter
} from "~/js/features/ExtractionApp/UiParametersSlice";

const Parameter = ({ id }) => {

  const appDetails = useSelector(selectAppDetails);
  const { name, content, dynamic, kind } = useSelector((state) => selectParameterById(state, id));
  
  const {
    saved,
    deleting,
    saving,
    running,
    error,
    hasRun,
    displayed,
  } = useSelector((state) => selectUiParameterById(state, id));

  const dispatch = useDispatch();
  
  const [nameValue, setNameValue]         = useState(name);
  const [contentValue, setContentValue]   = useState(content);
  const [kindValue,  setKindValue]        = useState(kind);
  const [showModal, setShowModal]         = useState(false);

  const handleSaveClick = () => {
    dispatch(
      updateParameter(
        {
          id: id,
          name: nameValue,
          content: contentValue,
          kind: kindValue,
          harvestDefinitionId: appDetails.harvestDefinition.id,
          pipelineId: appDetails.pipeline.id,
          extractionDefinitionId: appDetails.extractionDefinition.id,
          requestId: appDetails.request.id
        }
      )
    )
  }

  const isValid = () => {
    return nameValue.trim() !== "" && contentValue.trim() !== "";
  }

  const hasChanged = () => {
    return name !== nameValue || content !== contentValue || kind !== kindValue;
  }

  const isSaveable = () => {
    return isValid() && hasChanged() && !saving;
  }

  // TODO extract badge into a shared component for both apps
  
  const badgeText = () => {
    if (hasChanged()) {
      return "unsaved";
    } else if (saved) {
      return "saved";
    }
  };

  const parameterClasses = classNames("col-12", "collapse", "mt-4", { show: displayed });

  const badgeClasses = classNames({
    badge: true,
    "ms-2": true,
    "bg-primary": saved,
    "bg-secondary": hasChanged(),
  });
  
  const handleClose = () => setShowModal(false);
  const handleShow = () => setShowModal(true);
  
  const handleHideClick = () => {
    dispatch(toggleDisplayParameter({ id: id, displayed: false }))
  }
  
  const handleDeleteClick = () => {
    dispatch(
      deleteParameter({
        id: id,
        harvestDefinitionId: appDetails.harvestDefinition.id,
        pipelineId: appDetails.pipeline.id,
        extractionDefinitionId: appDetails.extractionDefinition.id,
        requestId: appDetails.request.id
      })
    );
    handleClose();
  };

  return (
    <>
      <div id={`parameter-${id}`} className={parameterClasses}>
        <div className="card">
          <div className="card-body">
            <div className="d-flex d-row justify-content-between align-items-center">
              <div>
                <h5 className="m-0 d-inline">Parameter!</h5>

                {name != "" && (
                  <span className={badgeClasses}>{badgeText()}</span>
                )}
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

            <div className='row mt-3'>
              <label className="col-form-label col-sm-1" htmlFor="name">
                <strong>Key</strong>
              </label>

              <div className='col-sm-5'>
                 <input 
                    type="text" 
                    className="form-control"
                    defaultValue={name}
                    onChange={(e) => setNameValue(e.target.value)}
                   />
              </div>
          
              <label className="col-form-label col-sm-1" htmlFor="name">
                <strong>Value</strong>
              </label>

              <div className='col-sm-5'>
                 <input 
                    type="text" 
                    className="form-control"
                    required="required"
                    defaultValue={contentValue}
                    onChange={(e) => setContentValue(e.target.value)}
                   />
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <Modal show={showModal} onHide={handleClose}>
        <Modal.Header closeButton>
          <Modal.Title>Delete</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          Are you sure you want to delete the parameter "{name}"?
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
  )
}

export default Parameter;
