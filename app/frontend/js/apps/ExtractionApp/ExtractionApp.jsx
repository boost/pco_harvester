import React from "react";
import { useSelector } from "react-redux";

import HeaderActions from "/js/apps/ExtractionApp/components/HeaderActions";
import NavTabs from "/js/apps/ExtractionApp/components/NavTabs";
import Request from "/js/apps/ExtractionApp/components/Request";
import ParameterList from "/js/apps/ExtractionApp/components/ParameterList";
import ParameterNavigationPanel from "/js/apps/ExtractionApp/components/ParameterNavigationPanel";

import StopConditionNavigationPanel from '/js/apps/ExtractionApp/components/StopConditionNavigationPanel';

import SharedDefinitionsView from "/js/components/SharedDefinitionsView";
import SharedDefinitionsModal from "/js/components/SharedDefinitionsModal";

import { selectAppDetails } from "~/js/features/TransformationApp/AppDetailsSlice";
import { selectUiAppDetails } from "~/js/features/TransformationApp/UiAppDetailsSlice";

const ExtractionApp = ({}) => {
  const appDetails = useSelector(selectAppDetails);
  const uiAppDetails = useSelector(selectUiAppDetails);

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
    return(
      <>
        <div className='col-2'>
          <StopConditionNavigationPanel />
        </div>

        <div className='col-10'>
          <p>Stop Conditions</p>
        </div>
      </>
    )
  }

  return (
    <>
      <HeaderActions />
      <NavTabs />

      <SharedDefinitionsModal pipelineId={appDetails.pipeline.id} />

      <div className="row">
        {(!uiAppDetails.sharedDefinitionsTabActive && !uiAppDetails.stopConditionsTabActive) && queryBuilderView()}
        {uiAppDetails.sharedDefinitionsTabActive && (
          <SharedDefinitionsView definitionType="extraction" />
        )}
        { uiAppDetails.stopConditionsTabActive && (
          stopConditionsView()
        )}
      </div>
    </>
  );
};

export default ExtractionApp;
