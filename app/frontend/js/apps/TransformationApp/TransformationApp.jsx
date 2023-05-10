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

import NavigationPanel from "~/js/apps/TransformationApp/components/NavigationPanel";
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
    <div className="text-bg-light p-2 row gy-4 mt-1">
      <div className="col-1 col-xxl-1 order-3 order-xxl-1">
        <div className="p-2 sticky-xxl-top">
          <NavigationPanel />
        </div>
      </div>
      <div className="col-6 col-xxl-3 order-2">
        <div className="p-2 sticky-xxl-top">
          <RecordViewer record={appDetails.rawRecord} />
        </div>
      </div>

      <div className="col-6 col-xxl-4 order-2 order-xxl-4">
        <div className="p-2 sticky-xxl-top">
          <RecordViewer record={appDetails.transformedRecord} />
        </div>
      </div>

      <div className="col-10 col-xxl-4 order-3 order-xxl-3">
        <div
          className="p-2"
          data-bs-spy="scroll"
          data-bs-target="#simple-list-example"
          data-bs-offset="0"
          data-bs-smooth-scroll="true"
        >

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
