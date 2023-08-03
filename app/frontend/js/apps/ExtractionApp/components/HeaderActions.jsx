import React, { useState } from "react";
import { createPortal } from "react-dom";
import { useDispatch, useSelector } from "react-redux";
import { map } from 'lodash';

import {
  selectUiRequestById,
} from "~/js/features/ExtractionApp/UiRequestsSlice";
import { selectRequestById, previewRequest } from "~/js/features/ExtractionApp/RequestsSlice";

import {
  selectAppDetails,
} from "~/js/features/ExtractionApp/AppDetailsSlice";

import Modal from "react-bootstrap/Modal";
import CodeEditor from "~/js/components/CodeEditor";

const HeaderActions = () => {

  const dispatch = useDispatch();

  const appDetails = useSelector(selectAppDetails);

  const { loading } = useSelector((state) => selectUiRequestById(state, 1));
  const { preview } = useSelector((state) => selectRequestById(state, 1));
  
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
          id: 1
        }
      )
    )
  }
  
  const { id, base_url, http_method, format } = useSelector((state) => selectRequestById(state, 1));

  return createPortal(
    <>
      <button className="btn btn-success" onClick={handlePreviewClick}>
        <i className="bi bi-play" aria-hidden="true"></i> Preview
      </button>
      
      <Modal size="lg" show={showModal} onHide={handleClose}>
        <Modal.Body>
          <div className="row">
            <div className="col-12">
              <h5>Initial Request</h5>

              { loading && (
                <div className='d-flex justify-content-center'>
                  <div className="spinner-border text-primary" role="status">
                    <span className="visually-hidden">Loading...</span>
                  </div>
                </div>
              ) }

              { !loading && (
                <>
                  <div className="accordion mt-4">

                    <div className="accordion-item">
                      <h2 className="accordion-header">
                        <button className="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#request" aria-expanded="true" aria-controls="request">
                          Request ({ http_method })
                        </button>
                      </h2>
                      <div id="request" className="accordion-collapse collapse show">
                        <div className="accordion-body">
                          <p>
                            { preview.url }
                          </p>
                        </div>
                      </div>
                    </div>
                    
                    <div className="accordion-item">
                      <h2 className="accordion-header">
                        <button className="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#headers" aria-expanded="true" aria-controls="response">
                          Request Headers
                        </button>
                      </h2>
                      <div id="headers" className="accordion-collapse collapse show">
                        <div className="accordion-body">

                          { map(preview.request_headers, (value, key) => {
                            return(
                              <p>
                                {key}: {value}
                              </p>
                            )
                          })}
                      
                        </div>
                      </div>
                    </div>
                
                    <div className="accordion-item">
                      <h2 className="accordion-header">
                        <button className="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#response" aria-expanded="true" aria-controls="response">
                          Response Body
                        </button>
                      </h2>
                      <div id="response" className="accordion-collapse collapse show">
                        <div className="accordion-body">
                          <CodeEditor initContent={preview.body} format={format} />
                        </div>
                      </div>
                    </div>
                                
                    <div className="accordion-item">
                      <h2 className="accordion-header">
                        <button className="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#response-headers" aria-expanded="true" aria-controls="response-headers">
                            Response Headers
                        </button>
                      </h2>
                      <div id="response-headers" className="accordion-collapse collapse show">
                        <div className="accordion-body">
                          
                          { map(preview.response_headers, (value, key) => {
                            return(
                              <p>
                                {key}: {value}
                              </p>
                            )
                          })}
                      
                        </div>
                      </div>
                    </div>
                  </div>              
                </>
              )}

            </div>
          </div>
        </Modal.Body>
      </Modal>
    </>,
    document.getElementById("react-header-actions")
  );

}

export default HeaderActions;
