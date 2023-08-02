import React, { useState } from "react";
import { createPortal } from "react-dom";
import { useDispatch, useSelector } from "react-redux";

import { filter, map } from 'lodash';

import { selectParameterIds, selectAllParameters } from "~/js/features/ExtractionApp/ParametersSlice";
import { selectRequestById } from "~/js/features/ExtractionApp/RequestsSlice";

import Modal from "react-bootstrap/Modal";
import CodeEditor from "~/js/components/CodeEditor";

const HeaderActions = () => {
  
  let allParameters = useSelector(selectAllParameters);
  allParameters = filter(allParameters, ['request_id', 1]);

  const slugParameters    = filter(allParameters, ['kind', 'slug']);
  const queryParameters   = filter(allParameters, ['kind', 'query']);
  const headerParameters  = filter(allParameters, ['kind', 'header']);
  
  const [showModal, setShowModal]         = useState(false);
  
  const handleClose = () => setShowModal(false);
  const handleShow = () => setShowModal(true);
  
  const { id, base_url, http_method } = useSelector((state) => selectRequestById(state, 1));

  return createPortal(
    <>

      <button className="btn btn-success" onClick={handleShow}>
        <i className="bi bi-play" aria-hidden="true"></i> Preview
      </button>
      
      <Modal size="lg" show={showModal} onHide={handleClose}>
        <Modal.Body>
          <div className="row">
            <div className="col-12">
              <h5>Initial Request</h5>

              <div className="accordion mt-4">

                <div className="accordion-item">
                  <h2 className="accordion-header">
                    <button className="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#request" aria-expanded="true" aria-controls="request">
                      URL ({ http_method })
                    </button>
                  </h2>
                  <div id="request" className="accordion-collapse collapse show">
                    <div className="accordion-body">
                      <p>
                        { base_url }

                        { map(slugParameters, (slugParameter) => {
                          return (
                            <>
                              /{slugParameter.content}
                            </>
                          )
                        })}
                        ?
                        { map(queryParameters, (queryParameter) => {
                          return (
                            <>
                              &{queryParameter.name}={queryParameter.content}
                            </>
                          )
                        })}
                      </p>
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

                      <CodeEditor
                        initContent={'hello!'}
                      />

                    </div>
                  </div>
                </div>
                
                <div className="accordion-item">
                  <h2 className="accordion-header">
                    <button className="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#headers" aria-expanded="true" aria-controls="response">
                      Headers
                    </button>
                  </h2>
                  <div id="headers" className="accordion-collapse collapse show">
                    <div className="accordion-body">
                      
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
                      
                    </div>
                  </div>
                </div>

              </div>              

            </div>

          </div>
        </Modal.Body>
      </Modal>
    </>,
    document.getElementById("react-header-actions")
  );

}

export default HeaderActions;
