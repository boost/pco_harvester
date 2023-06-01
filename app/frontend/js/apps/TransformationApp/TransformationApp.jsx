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

const TransformationApp = ({}) => {
  const dispatch = useDispatch();

  const fieldIds = useSelector(selectFieldIds);
  const appDetails = useSelector(selectAppDetails);
  const uiAppDetails = useSelector(selectUiAppDetails);

  const runAllFields = () => {
    dispatch(
      clickedOnRunFields({
        contentSourceId: appDetails.contentSource.id,
        transformationDefinitionId: appDetails.transformationDefinition.id,
        record: appDetails.rawRecord,
        fields: fieldIds,
      })
    );
  };

  const jumpToClasses = classNames({
    "col-1": true,
  });

  const { rawRecordExpanded, fieldsExpanded, transformedRecordExpanded } =
    uiAppDetails;

  const rawRecordClasses = classNames({
    "col-6": rawRecordExpanded && fieldsExpanded && transformedRecordExpanded,
    "col-5":
      (rawRecordExpanded && !fieldsExpanded && transformedRecordExpanded) ||
      (rawRecordExpanded && fieldsExpanded && !transformedRecordExpanded),
    "col-9": rawRecordExpanded && !fieldsExpanded && !transformedRecordExpanded,
    "col-1": !rawRecordExpanded,
  });

  const transformedRecordClasses = classNames({
    "col-3": transformedRecordExpanded && fieldsExpanded && rawRecordExpanded,
    "col-5":
      (transformedRecordExpanded && !fieldsExpanded && rawRecordExpanded) ||
      (transformedRecordExpanded && fieldsExpanded && !rawRecordExpanded),
    "col-9": transformedRecordExpanded && !fieldsExpanded && !rawRecordExpanded,
    "col-1": !transformedRecordExpanded,
  });

  const expandCollapseText = (section) => {
    if (uiAppDetails[section]) {
      return <i className="bi bi-arrow-bar-left" aria-label="collapse"></i>;
    } else {
      return <i className="bi bi-arrow-bar-right" aria-label="expand"></i>;
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
    <div class="row">
      <div className="col-2">
        <div className="card">
          <div className="card-body">
            <h5>Fields</h5>
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
      </div>

      <div className="col-10">
        <div className="row gy-4">
          <div className="col-6">
            <div className="card">
              <div className="card-body">
                <h5 className="float-start">Raw data</h5>
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
          </div>

          <div className="col-6">
            <div className="card">
              <div className="card-body">
                <h5 className="float-start">Transformed</h5>

                <button
                  onClick={() =>
                    clickToggleSection("transformedRecordExpanded")
                  }
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

          <div className="col-12">
            <div className="row gy-4">
              {map(fieldIds, (fieldId) => (
                <div className="col-12">
                  <Field id={fieldId} key={fieldId} />
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default TransformationApp;
