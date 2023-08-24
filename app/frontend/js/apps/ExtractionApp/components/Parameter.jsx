import React, { useState } from "react";
import { useSelector, useDispatch } from "react-redux";
import classNames from "classnames";
import { capitalize, filter, map } from 'lodash';

import ParameterDeleteModal from "~/js/apps/ExtractionApp/components/ParameterDeleteModal";
import CodeEditor from "~/js/components/CodeEditor";

import {
  selectParameterById,
  selectAllParameters,
  updateParameter,
} from "~/js/features/ExtractionApp/ParametersSlice";

import { selectAppDetails } from "~/js/features/ExtractionApp/AppDetailsSlice";
import { selectUiAppDetails } from "~/js/features/ExtractionApp/UiAppDetailsSlice";
import { selectRequestIds } from "~/js/features/ExtractionApp/RequestsSlice";

import {
  selectUiParameterById,
  toggleDisplayParameter,
} from "~/js/features/ExtractionApp/UiParametersSlice";

import Tooltip from '~/js/components/Tooltip';

const Parameter = ({ id }) => {
  const appDetails = useSelector(selectAppDetails);
  const uiAppDetails = useSelector(selectUiAppDetails);
  let allParameters = useSelector(selectAllParameters);

  const requestIds = useSelector(selectRequestIds);
  const initialRequestId = requestIds[0];
  const mainRequestId    = requestIds[1];

  allParameters = filter(allParameters, [
    "request_id",
    initialRequestId,
  ]);

  const initialRequestQueryParameters = filter(allParameters, ["kind", "query"]);

  const { name, content, content_type, kind } = useSelector((state) =>
    selectParameterById(state, id)
  );

  const { saved, deleting, saving, displayed } = useSelector((state) =>
    selectUiParameterById(state, id)
  );

  const dispatch = useDispatch();

  const [nameValue, setNameValue] = useState(name);
  const [contentValue, setContentValue] = useState(content);
  const [kindValue] = useState(kind);
  const [showModal, setShowModal] = useState(false);

  const handleSaveClick = () => {
    dispatch(
      updateParameter({
        id: id,
        name: nameValue,
        content: contentValue,
        kind: kindValue,
        harvestDefinitionId: appDetails.harvestDefinition.id,
        pipelineId: appDetails.pipeline.id,
        extractionDefinitionId: appDetails.extractionDefinition.id,
        requestId: uiAppDetails.activeRequest,
      })
    );
  };

  const isValid = () => {
    if (kind == "slug") {
      return contentValue.trim() !== "";
    }

    return nameValue.trim() !== "" && contentValue.trim() !== "";
  };

  const hasChanged = () => {
    return name !== nameValue || content !== contentValue || kind !== kindValue;
  };

  const isSaveable = () => {
    return isValid() && hasChanged() && !saving;
  };

  const badgeText = () => {
    if (hasChanged()) {
      return "unsaved";
    } else if (saved) {
      return "saved";
    }
  };

  const parameterClasses = classNames("col-12", "collapse", "mt-4", {
    show: displayed,
  });

  const badgeClasses = classNames({
    badge: true,
    "ms-2": true,
    "bg-primary": saved,
    "bg-secondary": hasChanged(),
  });

  const handleClose = () => setShowModal(false);
  const handleShow = () => setShowModal(true);

  const handleHideClick = () => {
    dispatch(toggleDisplayParameter({ id: id, displayed: false }));
  };

  const valueColumnClasses = classNames({
    "col-sm-5": kind != "slug",
    "col-sm-11": kind == "slug",
  });

  const displayName = () => {
    if (kind == "slug") {
      return content;
    }

    return name;
  };

  const handleDropdownClick = (value) => {
    dispatch(
      updateParameter({
        id: id,
        content_type: value,
        harvestDefinitionId: appDetails.harvestDefinition.id,
        pipelineId: appDetails.pipeline.id,
        extractionDefinitionId: appDetails.extractionDefinition.id,
        requestId: uiAppDetails.activeRequest,
      })
    );
  };

  return (
    <>
      <div id={`parameter-${id}`} className={parameterClasses}>
        <div className="card">
          <div className="card-body">
            <div className="d-flex d-row justify-content-between align-items-center">
              <div>
                <h5 className="m-0 d-inline">{displayName()}</h5>

                {displayName() != "" && (
                  <span className={badgeClasses}>{badgeText()}</span>
                )}
              </div>

              <div className="hstack gap-2">
                <div className="dropdown">
                  <button
                    className="btn btn-outline-primary dropdown-toggle"
                    type="button"
                    data-bs-toggle="dropdown"
                    aria-expanded="false"
                  >
                    <i className="bi bi-code-square" aria-hidden="true"></i>{" "}
                    { capitalize(content_type) }
                  </button>
                  <ul className="dropdown-menu">
                    <li>
                      <a
                        className="dropdown-item"
                        onClick={() => {
                          handleDropdownClick(0);
                        }}
                      >
                        Static
                      </a>
                    </li>
                    <li>
                      <a
                        className="dropdown-item"
                        onClick={() => {
                          handleDropdownClick(1);
                        }}
                      >
                        Dynamic
                      </a>
                    </li>
                    { (uiAppDetails.activeRequest == mainRequestId && kind == 'query') && (
                      <li>
                        <a
                          className="dropdown-item"
                          onClick={() => {
                            handleDropdownClick(2);
                          }}
                        >
                          Incremental
                        </a>
                      </li>
                    )}
                  </ul>
                </div>

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

            <div className="row mt-3">
              {kind != "slug" && (
                <>
                  <label className="col-form-label col-sm-1" htmlFor="name">
                    <strong>Key </strong>

                    {content_type == 'incremental' && (
                      <Tooltip data-bs-title="Please select the key of the initial request that you want to be incremented.">
                        <i
                          className="bi bi-question-circle"
                          aria-label="help text"
                        ></i>
                      </Tooltip>
                    )}
                  </label>
                
                  { content_type != 'incremental' && (
                    <div className="col-sm-5">
                      <input
                        type="text"
                        className="form-control"
                        defaultValue={name}
                        onChange={(e) => setNameValue(e.target.value)}
                      />
                    </div>
                  )}

                  { (content_type == 'incremental' && kind == 'query') && (
                    <div className="col-sm-5">
                      <select className="form-select" defaultValue={name} onChange={(e) => setNameValue(e.target.value)}>
                        { map(initialRequestQueryParameters, (parameter) => {
                          return (
                            <option value={parameter.name}>{ parameter.name }</option>
                          )
                        })}
                      </select>
                    </div> 
                  )}
                </>
              )}

              <label className="col-form-label col-sm-1" htmlFor="name">
                <strong>Value </strong>
                {content_type == 'incremental' && (
                    <Tooltip data-bs-title="Please input the amount you want this key to be incremented by">
                      <i
                        className="bi bi-question-circle"
                        aria-label="help text"
                      ></i>
                    </Tooltip>
                  )}
              </label>

              <div className={valueColumnClasses}>
                {content_type != 'dynamic' && (
                  <input
                    type="text"
                    className="form-control"
                    required="required"
                    defaultValue={contentValue}
                    onChange={(e) => setContentValue(e.target.value)}
                  />
                )}

                {content_type == 'dynamic' && (
                  <CodeEditor
                    initContent={content}
                    onChange={(e) => setContentValue(e.target.value)}
                  />
                )}
              </div>
            </div>
          </div>
        </div>
      </div>

      <ParameterDeleteModal showModal={showModal} handleClose={handleClose} id={id} name={name}/>

    </>
  );
};

export default Parameter;
