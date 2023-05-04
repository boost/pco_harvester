// Library Imports

import React from 'react';
import { map } from 'lodash';
import { useSelector } from 'react-redux';

// Fields from state

import { selectFields } from '~/js/features/FieldsSlice';
import { selectRawRecord } from '~/js/features/RawRecordSlice';
import { selectTransformedRecord } from '~/js/features/TransformedRecordSlice';

// Components

import RecordViewer from '~/js/apps/TransformationApp/components/RecordViewer';
import Field        from '~/js/apps/TransformationApp/components/Field';

const TransformationApp = ({}) => {

  const fields = useSelector(selectFields);
  const rawRecord = useSelector(selectRawRecord);
  const transformedRecord = useSelector(selectTransformedRecord);

  const fieldComponents = map(fields, (field) => (
    <Field 
      id={field.id}
      key={field.id}
      name={field.name}
      block={field.block}
    />
  ))
  
  return (
    <>
 
      <div className="row">
        <div className="col align-self-start">
          <RecordViewer record={rawRecord} />
        </div>

        <div className="col align-self-center">
          <RecordViewer record={transformedRecord} />
        </div>
      </div>

      <div className="mt-4"></div>

      { fieldComponents }      

      <div className="mt-2 float-end">
        <span className="btn btn-primary me-2">Add Field</span>
        <span className="btn btn-success">Run</span>
      </div>

      <div className="clearfix"></div>
    </>
  );
};

export default TransformationApp;
