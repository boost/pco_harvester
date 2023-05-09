// Library Imports

import React from "react";
import { map } from "lodash";
import { useDispatch, useSelector } from "react-redux";

// Actions from state

import { addField, selectFieldIds } from "~/js/features/FieldsSlice";

// Fields from state

import {
  selectAppDetails,
  clickedOnRunFields,
} from "~/js/features/AppDetailsSlice";

// Components

import RecordViewer from "~/js/apps/TransformationApp/components/RecordViewer";
import Field from "~/js/apps/TransformationApp/components/Field";
import AddField from "~/js/apps/TransformationApp/components/AddField";

const TransformationApp = ({}) => {
  const dispatch = useDispatch();

  const fieldIds = useSelector(selectFieldIds);
  const appDetails = useSelector(selectAppDetails);

  const fieldComponents = map(fieldIds, (fieldId) => (
    <Field id={fieldId} key={fieldId} />
  ));


  const runAllFields = async () => {
    await dispatch(
      clickedOnRunFields({
        contentPartnerId: appDetails.contentPartner.id,
        transformationDefinitionId: appDetails.transformationDefinition.id,
        record: appDetails.rawRecord,
        fields: fieldIds,
      })
    );
  };

  return (
    <div className="row gy-4 mt-1">
      <div className="col-6 col-xxl-4 order-1">
        <div className="sticky-xxl-top">
          <div className="border p-2">
            <h5>Raw Record</h5>
            <RecordViewer record={appDetails.rawRecord} />
          </div>
        </div>
      </div>

      <div className="col-6 col-xxl-4 order-2 order-xxl-3">
        <div className="sticky-xxl-top">
          <div className="border p-2">
            <h5>Transformed Record</h5>
            <RecordViewer record={appDetails.transformedRecord} />
          </div>
        </div>
      </div>

      <div className="col-12 col-xxl-4 order-3 order-xxl-2">
        <div className="border p-2">
          <h5>Fields</h5>

          {fieldComponents}

          <div className="mt-2 float-end">
            <AddField />
            <span className="btn btn-success" onClick={() => runAllFields()}>
              Run All
            </span>
          </div>

          <div className="clearfix"></div>
        </div>
      </div>
    </div>
  );
};

export default TransformationApp;
