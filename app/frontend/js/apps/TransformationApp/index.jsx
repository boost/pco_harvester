// Library Imports

import React                       from 'react';
import { map }                     from 'lodash';
import { useDispatch, useSelector } from 'react-redux';

// Actions from state

import { addField }                from '~/js/features/FieldsSlice';

// Fields from state

import { selectFields }            from '~/js/features/FieldsSlice';
import { selectRawRecord }         from '~/js/features/RawRecordSlice';
import { selectTransformedRecord } from '~/js/features/TransformedRecordSlice';


// Components

import RecordViewer from '~/js/apps/TransformationApp/components/RecordViewer';
import Field        from '~/js/apps/TransformationApp/components/Field';

const TransformationApp = ({}) => {

  const dispatch = useDispatch();
  
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

  const addNewField = async () => {
    const response = await dispatch(
      addField(
        {
          name: 'name',
          block: 'block',
          contentPartnerId: 1,
          transformationId: 5
        }
      )
    )
  }
  
  return (
    <>
 
      <div className="row mt-4">
        <div className="col align-self-start">
          <h5>Raw Record</h5>
          <RecordViewer record={rawRecord} />
        </div>

        <div className="col align-self-center">
          <h5>Transformed Record</h5>
          <RecordViewer record={transformedRecord} />
        </div>
      </div>

      <h5 className='mt-4'>Fields</h5>

      { fieldComponents }      

      <div className="mt-2 float-end">
        <span className="btn btn-primary me-2" onClick={ () => addNewField()}>Add Field</span>
        <span className="btn btn-success">Run</span>
      </div>

      <div className="clearfix"></div>
    </>
  );
};

export default TransformationApp;
