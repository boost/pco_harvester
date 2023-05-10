// Library Imports

import React from "react";
import { map } from "lodash";
import { useDispatch, useSelector } from "react-redux";
import classnames from "classnames";

// Actions from state

import { addField, selectFieldIds } from "~/js/features/FieldsSlice";
import { selectUiAppDetails } from "~/js/features/UiAppDetailsSlice";

// Fields from state

import {
  selectAppDetails,
  clickedOnRunFields,
} from "~/js/features/AppDetailsSlice";

import {
  toggleSection
} from '~/js/features/UiAppDetailsSlice';

// Components

import NavigationPanel from "~/js/apps/TransformationApp/components/NavigationPanel";
import RecordViewer from "~/js/apps/TransformationApp/components/RecordViewer";
import Field from "~/js/apps/TransformationApp/components/Field";
import AddField from "~/js/apps/TransformationApp/components/AddField";

const TransformationApp = ({}) => {
  const dispatch = useDispatch();

  const fieldIds = useSelector(selectFieldIds);
  const appDetails = useSelector(selectAppDetails);
  const uiAppDetails = useSelector(selectUiAppDetails);

  const fieldComponents = map(fieldIds, (fieldId) => (
    <Field id={fieldId} key={fieldId} />
  ));

  const runAllFields = () => {
    dispatch(
      clickedOnRunFields({
        contentPartnerId: appDetails.contentPartner.id,
        transformationDefinitionId: appDetails.transformationDefinition.id,
        record: appDetails.rawRecord,
        fields: fieldIds,
      })
    );
  };

  const rawRecordClasses = classnames({
    "col-3": uiAppDetails.rawRecordExpanded === true,
    "col-1": uiAppDetails.rawRecordExpanded === false
  });

  const fieldsClasses = classnames({
    "col": uiAppDetails.fieldsExpanded === true,
    "col-1": uiAppDetails.fieldsExpanded === false
  });
  
  const transformedRecordClasses = classnames({
    "col": uiAppDetails.transformedRecordExpanded === true,
    "col-1": uiAppDetails.transformedRecordExpanded === false
  });

  const expandCollapseText = (section) => {
    if (uiAppDetails[section]) {
      return 'Collapse';
    } else {
      return 'Expand';
    }
  }

  const clickToggleSection = (section) => {
    dispatch(
      toggleSection(
        {
          sectionName: section
        }
      )
    )
  }

  return (
    <div className="text-bg-light p-2 row gy-4 mt-1">

      <div className="col-1">
        <div className="p-2 sticky-xxl-top">
          <h5 className="float-start">Jump To</h5>

          <button className="btn btn-success float-end" onClick={() => runAllFields()}>
            Run All
          </button>
          <div className="clearfix"></div>

          <div className="mb-4"></div>
          <NavigationPanel />

          <AddField />
        </div>
      </div>

      <div className={ rawRecordClasses }>
        <div className="sticky-xxl-top">
          <h5 className="float-start">Raw</h5>
          <button onClick={ () => clickToggleSection('rawRecordExpanded') } type="button" className="btn btn-primary float-end">
            { expandCollapseText('rawRecordExpanded') }
          </button>
          <div className="clearfix"></div>

          <div className="mb-4"></div>
          <RecordViewer record={appDetails.rawRecord} />
        </div>
      </div>


      <div className={ fieldsClasses }>
        <h5 className="float-start">Fields</h5>
        <button onClick={ () => clickToggleSection('fieldsExpanded') } type="button" className="btn btn-primary float-end">
          { expandCollapseText('fieldsExpanded') }
        </button>
        <div className="clearfix"></div>

        <div className="mb-4"></div>
        <div
          className="p-2"
          data-bs-spy="scroll"
          data-bs-target="#simple-list-example"
          data-bs-offset="0"
          data-bs-smooth-scroll="true"
        >

          {fieldComponents}

          <div className="clearfix"></div>
        </div>
      </div>

      <div className={ transformedRecordClasses }>
        <div className="sticky-xxl-top">
          <h5 className="float-start">Transformed</h5>

          <button onClick={ () => clickToggleSection('transformedRecordExpanded') } type="button" className="btn btn-primary float-end">
            { expandCollapseText('transformedRecordExpanded') }
          </button>
          <div className="clearfix"></div>

          <div className="mb-4"></div>
          <RecordViewer record={appDetails.transformedRecord} />
        </div>
      </div>

    </div>
  );
};

export default TransformationApp;
