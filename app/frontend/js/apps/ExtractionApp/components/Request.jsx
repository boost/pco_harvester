import React from "react";

import { map, filter, concat } from "lodash";
import { useSelector, useDispatch } from "react-redux";

import {
  selectParameterIds,
  selectAllParameters,
} from "~/js/features/ExtractionApp/ParametersSlice";
import {
  selectRequestById,
  updateRequest,
} from "~/js/features/ExtractionApp/RequestsSlice";

import { selectAppDetails } from "~/js/features/ExtractionApp/AppDetailsSlice";

import { selectUiAppDetails } from "~/js/features/ExtractionApp/UiAppDetailsSlice";

import RequestFragment from "~/js/apps/ExtractionApp/components/RequestFragment";

const Request = ({}) => {
  const dispatch = useDispatch();
  const appDetails = useSelector(selectAppDetails);
  const uiAppDetails = useSelector(selectUiAppDetails);

  const { id, base_url, http_method } = useSelector((state) =>
    selectRequestById(state, uiAppDetails.activeRequest)
  );

  let allParameters = useSelector(selectAllParameters);
  allParameters = filter(allParameters, [
    "request_id",
    uiAppDetails.activeRequest,
  ]);

  const slugParameters = filter(allParameters, ["kind", "slug"]);
  const queryParameters = filter(allParameters, ["kind", "query"]);
  const headerParameters = filter(allParameters, ["kind", "header"]);

  const handleHttpMethodClick = (method) => {
    dispatch(
      updateRequest({
        id: id,
        base_url: base_url,
        http_method: method,
        harvestDefinitionId: appDetails.harvestDefinition.id,
        pipelineId: appDetails.pipeline.id,
        extractionDefinitionId: appDetails.extractionDefinition.id,
      })
    );
  };

  return (
    <div className="card">
      <div className="card-body">
        <div className="d-flex d-row justify-content-between align-items-center">
          <div>
            <h5 className="m-0 d-inline">Initial request URL</h5>
            <p>
              {queryParameters.length} query parameters, {slugParameters.length}{" "}
              slug parameters, and {headerParameters.length} header parameters.
            </p>
          </div>

          {
            // TODO once we support POST / GET requests
            // <div className="dropdown">
            //   <button className="btn btn-outline-primary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
            //     <i className="bi bi-arrow-down-up" aria-hidden="true"></i> { http_method }
            //   </button>
            //   <ul className="dropdown-menu">
            //     <li><a className="dropdown-item" onClick={ () => { handleHttpMethodClick('GET') }}>GET</a></li>
            //     <li><a className="dropdown-item" onClick={ () => { handleHttpMethodClick('POST') }}>POST</a></li>
            //   </ul>
            // </div>
          }
        </div>

        <strong className="float-start me-2">URL</strong>

        <p>
          {base_url}
          {map(slugParameters, (slugParameter, index) => {
            return (
              <RequestFragment
                id={slugParameter.id}
                index={index}
                key={slugParameter.id}
              />
            );
          })}

          {map(queryParameters, (queryParameter, index) => {
            return (
              <RequestFragment
                id={queryParameter.id}
                index={index}
                key={queryParameter.id}
              />
            );
          })}
        </p>
      </div>
    </div>
  );
};

export default Request;
