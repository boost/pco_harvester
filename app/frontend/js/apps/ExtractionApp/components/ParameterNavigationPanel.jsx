import React from "react";

import { filter, map } from "lodash";

import { selectAllParameters } from "~/js/features/ExtractionApp/ParametersSlice";
import { useSelector, useDispatch } from "react-redux";

import { toggleDisplayParameters } from "~/js/features/ExtractionApp/UiParametersSlice";

import { selectUiAppDetails } from "~/js/features/ExtractionApp/UiAppDetailsSlice";

import AddParameter from "~/js/apps/ExtractionApp/components/AddParameter";
import ParameterNavigationListItem from "~/js/apps/ExtractionApp/components/ParameterNavigationListItem";

const ParameterNavigationPanel = () => {
  const dispatch = useDispatch();
  const uiAppDetails = useSelector(selectUiAppDetails);

  let allParameters = useSelector(selectAllParameters);
  allParameters = filter(allParameters, [
    "request_id",
    uiAppDetails.activeRequest,
  ]);

  const queryParameters = filter(allParameters, ["kind", "query"]);
  const headerParameters = filter(allParameters, ["kind", "header"]);
  const slugParameters = filter(allParameters, ["kind", "slug"]);

  return (
    <div className="card field-nav-panel">
      <div className="d-flex flex-column overflow-auto">
        <div className="field-nav-panel__header">
          <h5>Query</h5>

          <div className="btn-group card__control">
            <i
              className="bi bi-three-dots-vertical"
              data-bs-toggle="dropdown"
            ></i>
            <ul className="dropdown-menu dropdown-menu-end">
              <li
                className="dropdown-item card__control-action"
                onClick={() => {
                  dispatch(
                    toggleDisplayParameters({
                      parameters: queryParameters,
                      displayed: false,
                    })
                  );
                }}
              >
                <i className="bi bi-eye-slash me-2"></i> Hide all
              </li>

              <li
                className="dropdown-item card__control-action"
                onClick={() => {
                  dispatch(
                    toggleDisplayParameters({
                      parameters: queryParameters,
                      displayed: true,
                    })
                  );
                }}
              >
                <i className="bi bi-eye me-2"></i> Show all
              </li>
            </ul>
          </div>
        </div>

        <div className="field-nav-panel__content">
          <AddParameter buttonText="+ Add" kind="query" />

          <ul className="field-nav nav nav-pills flex-column overflow-auto flex-nowrap">
            {map(queryParameters, (queryParameter) => {
              return (
                <ParameterNavigationListItem
                  id={queryParameter.id}
                  key={queryParameter.id}
                />
              );
            })}
          </ul>
        </div>

        <div className="field-nav-panel__header field-nav-panel__header--fields">
          <h5>Header</h5>

          <div className="btn-group card__control">
            <i
              className="bi bi-three-dots-vertical"
              data-bs-toggle="dropdown"
            ></i>
            <ul className="dropdown-menu dropdown-menu-end">
              <li
                className="dropdown-item card__control-action"
                onClick={() => {
                  dispatch(
                    toggleDisplayParameters({
                      parameters: headerParameters,
                      displayed: false,
                    })
                  );
                }}
              >
                <i className="bi bi-eye-slash me-2"></i> Hide all
              </li>

              <li
                className="dropdown-item card__control-action"
                onClick={() => {
                  dispatch(
                    toggleDisplayParameters({
                      parameters: headerParameters,
                      displayed: true,
                    })
                  );
                }}
              >
                <i className="bi bi-eye me-2"></i> Show all
              </li>
            </ul>
          </div>
        </div>

        <div className="field-nav-panel__content">
          <AddParameter buttonText="+ Add" kind="header" />

          <ul className="field-nav nav nav-pills flex-column overflow-auto flex-nowrap">
            {map(headerParameters, (headerParameter) => {
              return (
                <ParameterNavigationListItem
                  id={headerParameter.id}
                  key={headerParameter.id}
                />
              );
            })}
          </ul>
        </div>

        <div className="field-nav-panel__header field-nav-panel__header--fields">
          <h5>Slug</h5>

          <div className="btn-group card__control">
            <i
              className="bi bi-three-dots-vertical"
              data-bs-toggle="dropdown"
            ></i>
            <ul className="dropdown-menu dropdown-menu-end">
              <li
                className="dropdown-item card__control-action"
                onClick={() => {
                  dispatch(
                    toggleDisplayParameters({
                      parameters: slugParameters,
                      displayed: false,
                    })
                  );
                }}
              >
                <i className="bi bi-eye-slash me-2"></i> Hide all
              </li>

              <li
                className="dropdown-item card__control-action"
                onClick={() => {
                  dispatch(
                    toggleDisplayParameters({
                      parameters: slugParameters,
                      displayed: true,
                    })
                  );
                }}
              >
                <i className="bi bi-eye me-2"></i> Show all
              </li>
            </ul>
          </div>
        </div>

        <div className="field-nav-panel__content">
          <AddParameter buttonText="+ Add" kind="slug" />

          <ul className="field-nav nav nav-pills flex-column overflow-auto flex-nowrap">
            {map(slugParameters, (slugParameter, index) => {
              return (
                <ParameterNavigationListItem
                  id={slugParameter.id}
                  key={slugParameter.id}
                  index={index}
                />
              );
            })}
          </ul>
        </div>
      </div>
    </div>
  );
};

export default ParameterNavigationPanel;
