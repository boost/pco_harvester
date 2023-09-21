import React from "react";
import { map } from "lodash";

const SharedDefinitionsView = ({definitionType, sharedDefinitions}) => {
  return (
    <>
      <p>These pipelines all share this {definitionType} definition</p> 

      <div className="row">
        {
          map(sharedDefinitions, (sharedDefinition) => {
            return(
              <div className='col-3' key={sharedDefinition.id}>
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
  );
};

export default SharedDefinitionsView;
