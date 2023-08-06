import React from "react";

import { useDispatch, useSelector } from "react-redux";
import { map } from 'lodash';

import {
  selectUiRequestById,
} from "~/js/features/ExtractionApp/UiRequestsSlice";
import { selectRequestById, previewRequest } from "~/js/features/ExtractionApp/RequestsSlice";

import CodeEditor from "~/js/components/CodeEditor";

const Preview = ({ id }) => {

  const { loading } = useSelector((state) => selectUiRequestById(state, id));
  const { preview, format } = useSelector((state) => selectRequestById(state, id));
  
  return (
    <>
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
                  Request ({ preview.method })
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
                      <p key={key}>
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
    </>
  )
}

export default Preview;
