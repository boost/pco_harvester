import React from "react";
import { useSelector } from "react-redux";

import HeaderActions from "/js/apps/ExtractionApp/components/HeaderActions";
import NavTabs from "/js/apps/ExtractionApp/components/NavTabs";
import Request from "/js/apps/ExtractionApp/components/Request";
import ParameterList from "/js/apps/ExtractionApp/components/ParameterList";
import ParameterNavigationPanel from "/js/apps/ExtractionApp/components/ParameterNavigationPanel";

import StopConditionNavigationPanel from "/js/apps/ExtractionApp/components/StopConditionNavigationPanel";
import StopCondition from "/js/apps/ExtractionApp/components/StopCondition";

import SharedDefinitionsView from "/js/components/SharedDefinitionsView";
import SharedDefinitionsModal from "/js/components/SharedDefinitionsModal";

import { selectAppDetails } from "~/js/features/TransformationApp/AppDetailsSlice";
import { selectUiAppDetails } from "~/js/features/TransformationApp/UiAppDetailsSlice";

import { selectStopConditionIds } from "/js/features/ExtractionApp/StopConditionsSlice";
import { map } from "lodash";

const ExtractionApp = ({}) => {
  const appDetails = useSelector(selectAppDetails);
  const uiAppDetails = useSelector(selectUiAppDetails);

  const stopConditionIds = useSelector(selectStopConditionIds);

  const queryBuilderView = () => {
    return (
      <>
        <div className="col-2">
          <ParameterNavigationPanel />
        </div>

        <div className="col-10">
          <Request />

          <ParameterList requestId={uiAppDetails.activeRequest} kind="query" />
          <ParameterList requestId={uiAppDetails.activeRequest} kind="header" />
          <ParameterList requestId={uiAppDetails.activeRequest} kind="slug" />
        </div>
      </>
    );
  };

  const stopConditionsView = () => {
    return (
      <>
        <div className="col-2">
          <StopConditionNavigationPanel />
        </div>

        <div className="col-10">
          <div class="card">
            <div class="card-body">
              <h5>Stop Conditions</h5>

              <p>
                This is how you tell an extraction to stop. By default an
                extraction will stop when one of the following conditions have
                been met:
              </p>

              <ul>
                <li>The extraction has reached a set number of pages.</li>

                <li>
                  The content source has returned an unsuccessful status code.
                </li>

                <li>
                  The exact same document has been extracted twice in a row.
                </li>
              </ul>

              <p>
                If the above conditions aren't enough for your use case, you can
                add custom stop conditions here. Note that stop conditions are
                not evaluated as part of the extraction preview.
              </p>
            </div>
          </div>

          {map(stopConditionIds, (stopConditionId) => (
            <StopCondition id={stopConditionId} key={stopConditionId} />
          ))}
        </div>
      </>
    );
  };

  return (
    <>
      <HeaderActions />
      <NavTabs />

      <SharedDefinitionsModal pipelineId={appDetails.pipeline.id} />

      <div className="row">
        {!uiAppDetails.sharedDefinitionsTabActive &&
          !uiAppDetails.stopConditionsTabActive &&
          queryBuilderView()}
        {uiAppDetails.sharedDefinitionsTabActive && (
          <SharedDefinitionsView definitionType="extraction" />
        )}
        {uiAppDetails.stopConditionsTabActive && stopConditionsView()}
      </div>
    </>
  );
};

export default ExtractionApp;
