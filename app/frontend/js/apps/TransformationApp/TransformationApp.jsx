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
import { selectAppDetails } from "~/js/features/AppDetailsSlice";

// Components
import RecordViewer from "~/js/apps/TransformationApp/components/RecordViewer";
import Field from "~/js/apps/TransformationApp/components/Field";
import FieldNavigationPanel from "./components/FieldNavigationPanel";
import ExpandCollapseIcon from "./components/ExpandCollapseIcon";
import HeaderActions from "./components/HeaderActions";

const TransformationApp = ({}) => {
  const dispatch = useDispatch();

  const fieldIds = useSelector(selectFieldIds);
  const appDetails = useSelector(selectAppDetails);
  const uiAppDetails = useSelector(selectUiAppDetails);

  const { fieldNavExpanded, rawRecordExpanded, transformedRecordExpanded } =
    uiAppDetails;

  const rawRecordClasses = classNames({
    "col-6": rawRecordExpanded && transformedRecordExpanded,
    "col-10": rawRecordExpanded && !transformedRecordExpanded,
    "col-2": !rawRecordExpanded,
  });

  const transformedRecordClasses = classNames({
    "col-6": transformedRecordExpanded && rawRecordExpanded,
    "col-10": transformedRecordExpanded && !rawRecordExpanded,
    "col-2": !transformedRecordExpanded,
  });

  const clickToggleSection = (section) => {
    dispatch(
      toggleSection({
        sectionName: section,
      })
    );
  };

  return (
    <div className="row">
      <HeaderActions />

      <div className="col-2">
        <FieldNavigationPanel />
      </div>

      <div className="col-10">
        <div className="row gy-4">
          <div className={rawRecordClasses}>
            <div className="card">
              <div className="card-body">
                <h5 className="float-start">Raw data</h5>
                <button
                  onClick={() => clickToggleSection("rawRecordExpanded")}
                  type="button"
                  className="btn btn-primary float-end"
                >
                  <ExpandCollapseIcon
                    expanded={uiAppDetails["rawRecordExpanded"]}
                  />
                </button>
                <div className="clearfix"></div>

                <div className="mb-4"></div>
                <RecordViewer record={appDetails.rawRecord} />
              </div>
            </div>
          </div>

          <div className={transformedRecordClasses}>
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
                  <ExpandCollapseIcon
                    expanded={uiAppDetails["transformedRecordExpanded"]}
                  />
                </button>
                <div className="clearfix"></div>

                <div className="mb-4"></div>
                <RecordViewer record={appDetails.transformedRecord} />
              </div>
            </div>
          </div>

          <div className="col-12 mb-4">
            <div className="row gy-4">
              {map(fieldIds, (fieldId) => (
                <Field id={fieldId} key={fieldId} />
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default TransformationApp;
