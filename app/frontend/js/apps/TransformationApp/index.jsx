// Library Imports

import React                       from 'react';
import { map }                     from 'lodash';
import { useDispatch, useSelector } from 'react-redux';

// Actions from state

import { addField }                from '~/js/features/FieldsSlice';

// Fields from state

import { selectAllFields }            from '~/js/features/FieldsSlice';
import { selectRawRecord }         from '~/js/features/RawRecordSlice';
import { selectTransformedRecord } from '~/js/features/TransformedRecordSlice';
import { selectContentPartner }    from '~/js/features/ContentPartnerSlice';
import { selectTransformation }    from '~/js/features/TransformationSlice';


// Components

import RecordViewer from '~/js/apps/TransformationApp/components/RecordViewer';
import Field        from '~/js/apps/TransformationApp/components/Field';

const TransformationApp = ({}) => {

  const dispatch = useDispatch();
  
  const fields = useSelector(selectAllFields);
  const rawRecord = useSelector(selectRawRecord);
  const transformedRecord = useSelector(selectTransformedRecord);
  const contentPartner = useSelector(selectContentPartner);
  const transformation = useSelector(selectTransformation);

  const fieldComponents = map(fields, (field) => (
    <Field 
      id={field.id}
      key={field.id}
      name={field.name}
      block={field.block}
    />
  ))

  const addNewField = async () => {
    await dispatch(
      addField(
        {
          name: '',
          block: '',
          contentPartnerId: contentPartner.id,
          transformationId: transformation.id,
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
