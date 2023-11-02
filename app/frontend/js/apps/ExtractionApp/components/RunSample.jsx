import React from 'react';
import { useSelector } from "react-redux";
import { selectAppDetails } from "~/js/features/ExtractionApp/AppDetailsSlice";
import { request } from "~/js/utils/request";

const RunSample = () => {
  const appDetails = useSelector(selectAppDetails);

  const handleClick = async () => {
    const response = await request
      .post(
        `/pipelines/${appDetails.pipeline.id}/harvest_definitions/${appDetails.harvestDefinition.id}/extraction_definitions/${appDetails.extractionDefinition.id}/extraction_jobs.json?kind=sample`
      )
      .then((response) => {
        return response;
      });

    window.location.replace(response.data.location);
  };

    return(
      <button
        className="btn btn-primary me-2"
        onClick={() => {
          handleClick();
        }}
      >
        <i className="bi bi-play me-1" aria-hidden="true"></i>
        Run sample and transform data
      </button>
    )
}

export default RunSample;