import React from "react";

import { map } from "lodash";

import { useSelector } from "react-redux";

import HeaderActions from "/js/apps/ExtractionApp/components/HeaderActions";
import NavTabs from "/js/apps/ExtractionApp/components/NavTabs";
import Request from "/js/apps/ExtractionApp/components/Request";
import Parameter from "/js/apps/ExtractionApp/components/Parameter";
import ParameterNavigationPanel from "/js/apps/ExtractionApp/components/ParameterNavigationPanel";

import { selectParameterIds } from "~/js/features/ExtractionApp/ParametersSlice";

import { selectAppDetails } from "~/js/features/AppDetailsSlice";

const ExtractionApp = ({}) => {
  const parameterIds = useSelector(selectParameterIds);
  const appDetails = useSelector(selectAppDetails);

  return (
    <>
      <HeaderActions />
      {appDetails.extractionDefinition.paginated && <NavTabs />}

      <div className="row">
        <div className="col-2">
          <ParameterNavigationPanel />
        </div>

        <div className="col-10">
          <Request />

          {map(parameterIds, (parameterId) => (
            <Parameter id={parameterId} key={parameterId} />
          ))}
        </div>
      </div>
    </>
  );
};

export default ExtractionApp;
