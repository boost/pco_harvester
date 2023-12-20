import React from "react";

import AddStopCondition from "./AddStopCondition";

import Tooltip from "~/js/components/Tooltip";

const StopConditionNavigationPanel = () => {
  return (
    <div className="card field-nav-panel">
      <div className="d-flex flex-column overflow-auto">
        <div className="field-nav-panel__header">
          <Tooltip data-bs-title="Stop conditions are how you tell an extraction to stop. By default an extraction will stop for the following reasons: It has reached a set number of pages, the content source returns an unsuccessful status code, or the exact same document has been extracted twice in a row.">
            <h5>Stop Conditions</h5>
          </Tooltip>

          <div className="btn-group card__control">
            <i
              className="bi bi-three-dots-vertical"
              data-bs-toggle="dropdown"
            ></i>

            <ul className="dropdown-menu dropdown-menu-end">
              <li
                className="dropdown-item card__control-action"
                onClick={() => {
                  // dispatch(
                  //   toggleDisplayParameters({
                  //     parameters: queryParameters,
                  //     displayed: false,
                  //   })
                  // );
                }}
              >
                <i className="bi bi-eye-slash me-2"></i> Hide all
              </li>

              <li
                className="dropdown-item card__control-action"
                onClick={() => {
                  // dispatch(
                  //   toggleDisplayParameters({
                  //     parameters: queryParameters,
                  //     displayed: true,
                  //   })
                  // );
                }}
              >
                <i className="bi bi-eye me-2"></i> Show all
              </li>
            </ul>
          </div>
        </div>

        <div className="field-nav-panel__content">
          <AddStopCondition />

          <ul className="field-nav nav nav-pills flex-column overflow-auto flex-nowrap">
            {/* <ParameterNavigationList
              requestId={uiAppDetails.activeRequest}
              kind="query"
            /> */}
          </ul>
        </div>
      </div>
    </div>
  );
};

export default StopConditionNavigationPanel;
