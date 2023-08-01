import React from "react";

import { map } from 'lodash';

import { useDispatch, useSelector } from "react-redux";


import Request from '/js/apps/ExtractionApp/components/Request';
import Parameter from '/js/apps/ExtractionApp/components/Parameter';
import ParameterNavigationPanel from '/js/apps/ExtractionApp/components/ParameterNavigationPanel';

import { selectParameterIds } from "~/js/features/ExtractionApp/ParametersSlice";

const ExtractionApp = ({}) => {

  const parameterIds = useSelector(selectParameterIds);

  return(
    <div className='row'>
      <div className='col-2'>
        <ParameterNavigationPanel />
      </div>

      <div className='col-10'>
        <Request />

        { map(parameterIds, (parameterId) => (
          <Parameter id={parameterId} key={parameterId} />
        ))}

      </div>
    </div>
  )
}

export default ExtractionApp;
