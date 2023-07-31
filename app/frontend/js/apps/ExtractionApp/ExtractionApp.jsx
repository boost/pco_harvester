import React from "react";

import Request from '/js/apps/ExtractionApp/components/Request';
import Parameter from '/js/apps/ExtractionApp/components/Parameter';
import ParameterNavigationPanel from '/js/apps/ExtractionApp/components/ParameterNavigationPanel';

const ExtractionApp = ({}) => {
  return(
    <div className='row'>
      <div className='col-2'>
        <ParameterNavigationPanel />
      </div>

      <div className='col-10'>
        <Request />

        <Parameter />
      </div>
    </div>
  )
}

export default ExtractionApp;
