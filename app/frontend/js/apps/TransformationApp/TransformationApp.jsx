// Library Imports
import React from "react";
import { map } from "lodash";
import { useDispatch, useSelector } from "react-redux";
import classNames from "classnames";

// Actions from state
import { selectFieldIds } from "~/js/features/FieldsSlice";
import { selectUiAppDetails } from "~/js/features/UiAppDetailsSlice";
import { toggleSection } from "~/js/features/UiAppDetailsSlice";

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
import { ReactComponent as ArrowBarLeft } from "bootstrap-icons/icons/arrow-bar-left.svg";
import { ReactComponent as ArrowBarRight } from "bootstrap-icons/icons/arrow-bar-right.svg";

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

  const jumpToClasses = classNames({
    "col-1": true,
  });

  const rawRecordClasses = classNames({
    "col-3": uiAppDetails.rawRecordExpanded === true,
    "col-1": uiAppDetails.rawRecordExpanded === false,
  });

  const fieldsClasses = classNames({
    "col-5": uiAppDetails.fieldsExpanded === true,
    "col-1": uiAppDetails.fieldsExpanded === false,
  });

  const transformedRecordClasses = classNames({
    "col-3": uiAppDetails.transformedRecordExpanded === true,
    "col-1": uiAppDetails.transformedRecordExpanded === false,
  });

  const expandCollapseText = (section) => {
    if (uiAppDetails[section]) {
      return <ArrowBarLeft aria-label="collapse" />;
    } else {
      return <ArrowBarRight aria-label="expand" />;
    }
  };

  const clickToggleSection = (section) => {
    dispatch(
      toggleSection({
        sectionName: section,
      })
    );
  };

  return (
    <div className="text-bg-light p-2 row gy-4 mt-1">
      <div className={jumpToClasses}>
        <div className="sticky-top vh-100 pb-2">
          <h5>Jump To</h5>

          <button
            className="btn btn-success mb-4"
            onClick={() => runAllFields()}
          >
            Run All
          </button>

          <NavigationPanel />
          <AddField />
        </div>
      </div>

      <div className={rawRecordClasses}>
        <div className="sticky-top vh-100">
          <h5 className="float-start">Raw</h5>
          <button
            onClick={() => clickToggleSection("rawRecordExpanded")}
            type="button"
            className="btn btn-primary float-end"
          >
            {expandCollapseText("rawRecordExpanded")}
          </button>
          <div className="clearfix"></div>

          <div className="mb-4"></div>
          <RecordViewer record={appDetails.rawRecord} />
        </div>
      </div>

      <div className={fieldsClasses}>
        <h5 className="float-start">Fields</h5>
        <button
          onClick={() => clickToggleSection("fieldsExpanded")}
          type="button"
          className="btn btn-primary float-end"
        >
          {expandCollapseText("fieldsExpanded")}
        </button>
        <div className="clearfix"></div>

        <div className="mb-4"></div>
        <div
          data-bs-spy="scroll"
          data-bs-target="#field-list"
          data-bs-offset="0"
          data-bs-smooth-scroll="true"
        >
          {fieldComponents}

          <div className="clearfix"></div>
        </div>
      </div>

      <div className={transformedRecordClasses}>
        <div className="sticky-top vh-100">
          <h5 className="float-start">Transformed</h5>

          <button
            onClick={() => clickToggleSection("transformedRecordExpanded")}
            type="button"
            className="btn btn-primary float-end"
          >
            {expandCollapseText("transformedRecordExpanded")}
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
