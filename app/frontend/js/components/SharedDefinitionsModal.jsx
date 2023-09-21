import React, { useEffect, useState } from "react";
import { createPortal } from "react-dom";
import { useSelector } from "react-redux";
import { selectAllSharedDefinitions } from "~/js/features/SharedDefinitionsSlice";
import { map } from "lodash";

import Button from "react-bootstrap/Button";
import Modal from "react-bootstrap/Modal";

const SharedDefinitionsModal = ({ pipelineId }) => {
  const sharedDefinitions = useSelector(selectAllSharedDefinitions);

  const [showModal, setShowModal] = useState(false);
  const handleShowModalClose = () => setShowModal(false);

  useEffect(() => {
    setShowModal(sharedDefinitions.length > 1);
  }, [sharedDefinitions]);

  return createPortal(
    <Modal
      size="lg"
      show={showModal}
      onHide={handleShowModalClose}
      className="modal"
    >
      <Modal.Header closeButton>
        <Modal.Title>Edit shared definition</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <div className="row">
          <div className="col">
            <p>
              Are you sure you want to edit this definition? Any changes you
              make will also be applied to these pipelines:
            </p>
            <ul className="mt-2">
              {map(sharedDefinitions, (sharedDefinition) => {
                return (
                  <li key={sharedDefinition.id}>
                    {sharedDefinition.pipeline.name}
                  </li>
                );
              })}
            </ul>
          </div>
        </div>
      </Modal.Body>
      <Modal.Footer>
        <Button href={`/pipelines/${pipelineId}`} variant="secondary">
          Back to pipeline
        </Button>
        <Button variant="primary" onClick={handleShowModalClose}>
          Edit Shared Definition
        </Button>
      </Modal.Footer>
    </Modal>,
    document.getElementById("react-modals")
  );
};

export default SharedDefinitionsModal;
