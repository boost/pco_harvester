import React from "react";
import { map, filter } from "lodash";
import { useSelector } from "react-redux";

import HeaderActions from "/js/apps/ExtractionApp/components/HeaderActions";
import NavTabs from "/js/apps/ExtractionApp/components/NavTabs";
import Request from "/js/apps/ExtractionApp/components/Request";
import Parameter from "/js/apps/ExtractionApp/components/Parameter";
import ParameterNavigationPanel from "/js/apps/ExtractionApp/components/ParameterNavigationPanel";

import { selectAllParameters } from "~/js/features/ExtractionApp/ParametersSlice";
import { selectAllSharedDefinitions } from "~/js/features/SharedDefinitionsSlice";
import { selectAppDetails } from "~/js/features/TransformationApp/AppDetailsSlice";
import { selectUiAppDetails } from "~/js/features/TransformationApp/UiAppDetailsSlice";

const ExtractionApp = ({}) => {
  const appDetails = useSelector(selectAppDetails);
  const uiAppDetails = useSelector(selectUiAppDetails);
  const sharedDefinitions = useSelector(selectAllSharedDefinitions);

  let allParameters = useSelector(selectAllParameters);
  allParameters = filter(allParameters, [
    "request_id",
    uiAppDetails.activeRequest,
  ]);

  const queryParameters = filter(allParameters, ["kind", "query"]);
  const headerParameters = filter(allParameters, ["kind", "header"]);
  const slugParameters = filter(allParameters, ["kind", "slug"]);

  const queryBuilderView = () => {
    return (
      <>
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
      </>
    )
  }

  const sharedDefinitionsView = () => {
    return (
      <>
        <p>These pipelines all share this extraction definition</p> 

        <div className="row">
          {
            map(sharedDefinitions, (sharedDefinition) => {
              return(
                <div className='col-3'>
                  <a className="card mb-3" href={`/pipelines/${sharedDefinition.pipeline.id}`}>
                    <div className="card-body">
                      <h5 className="card-title">{ sharedDefinition.pipeline.name }</h5>

                      <span className="badge bg-light text-dark">
                        { sharedDefinition.pipeline.harvests } Harvest
                      </span>
                      <span className="badge bg-light text-dark">
                        { sharedDefinition.pipeline.enrichments } Enrichments
                      </span>
                    </div>
                  </a>
                </div>
              );
            })
          }
        </div>
      </>
    )
  }

  return (
    <>
      <HeaderActions />
      <NavTabs />

      <div className="row">
        { !uiAppDetails.sharedTabActive && queryBuilderView() }
        { uiAppDetails.sharedTabActive && sharedDefinitionsView() }
      </div>
    </>
  );
};

export default ExtractionApp;
