import React from "react";


import { useSelector, useDispatch } from 'react-redux';
import AddStopCondition from "./AddStopCondition";
import StopConditionNavigationListItem from './StopConditionNavigationListItem';

import { selectAllStopConditions } from '~/js/features/ExtractionApp/StopConditionsSlice';
import { toggleDisplayStopConditions } from "~/js/features/ExtractionApp/UiStopConditionsSlice";

const StopConditionNavigationPanel = () => {

  const dispatch = useDispatch();

  const stopConditions = useSelector(selectAllStopConditions);

  return (
    <div className="card field-nav-panel">
      <div className="d-flex flex-column overflow-auto">
        <div className="field-nav-panel__header">
          <h5>Stop Conditions</h5>

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
                    toggleDisplayStopConditions({
                      stopConditions: stopConditions,
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
                    toggleDisplayStopConditions({
                      stopConditions: stopConditions,
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
          <AddStopCondition />

          <ul className="field-nav nav nav-pills flex-column overflow-auto flex-nowrap">

            { stopConditions.map((stopCondition) => {
              return <StopConditionNavigationListItem id={stopCondition.id} key={stopCondition.id} />;
            })} 
            
          </ul>
        </div>
      </div>
    </div>
  );
};

export default StopConditionNavigationPanel;
