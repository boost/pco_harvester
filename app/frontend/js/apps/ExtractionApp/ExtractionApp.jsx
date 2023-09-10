import React from "react";
import { map, filter } from "lodash";
import { useSelector } from "react-redux";

import HeaderActions from "/js/apps/ExtractionApp/components/HeaderActions";
import NavTabs from "/js/apps/ExtractionApp/components/NavTabs";
import Request from "/js/apps/ExtractionApp/components/Request";
import Parameter from "/js/apps/ExtractionApp/components/Parameter";
import ParameterNavigationPanel from "/js/apps/ExtractionApp/components/ParameterNavigationPanel";

import { selectAllParameters } from "~/js/features/ExtractionApp/ParametersSlice";
import { selectAppDetails } from "~/js/features/TransformationApp/AppDetailsSlice";
import { selectUiAppDetails } from "~/js/features/TransformationApp/UiAppDetailsSlice";

const ExtractionApp = ({}) => {
  const appDetails = useSelector(selectAppDetails);
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
    <>
      <HeaderActions />
      {appDetails.extractionDefinition.paginated && <NavTabs />}

      <div className="row">
        <div className="col-2">
          <ParameterNavigationPanel />
        </div>

        <div className="col-10">
          <Request />

          {map(queryParameters, (parameter) => (
            <Parameter id={parameter.id} key={parameter.id} />
          ))}

          {map(headerParameters, (parameter) => (
            <Parameter id={parameter.id} key={parameter.id} />
          ))}

          {map(slugParameters, (parameter) => (
            <Parameter id={parameter.id} key={parameter.id} />
          ))}
        </div>
      </div>
    </>
  );
};

export default ExtractionApp;
