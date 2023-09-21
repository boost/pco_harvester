// Library Imports
import React from "react";
import { map, isEmpty } from "lodash";
import { useDispatch, useSelector } from "react-redux";
import classNames from "classnames";

// Actions from state
import { selectFieldIds } from "~/js/features/TransformationApp/FieldsSlice";
import { selectUiAppDetails } from "~/js/features/TransformationApp/UiAppDetailsSlice";
import { toggleSection } from "~/js/features/TransformationApp/UiAppDetailsSlice";

// Fields from state
import { selectAppDetails } from "~/js/features/TransformationApp/AppDetailsSlice";

// Components
import RecordViewer from "~/js/apps/TransformationApp/components/RecordViewer";
import Field from "~/js/apps/TransformationApp/components/Field";
import FieldNavigationPanel from "./components/FieldNavigationPanel";
import ExpandCollapseIcon from "./components/ExpandCollapseIcon";
import HeaderActions from "./components/HeaderActions";
import NavTabs from "./components/NavTabs";
import RawDataBody from "./RawDataBody";

import SharedDefinitionsView from "/js/components/SharedDefinitionsView";
import SharedDefinitionsModal from "/js/components/SharedDefinitionsModal";

const TransformationApp = ({}) => {
  const dispatch = useDispatch();

  const fieldIds = useSelector(selectFieldIds);
  const appDetails = useSelector(selectAppDetails);
  const uiAppDetails = useSelector(selectUiAppDetails);

  const { rawRecordExpanded, transformedRecordExpanded } = uiAppDetails;

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

  const transformedRecord = () => {
    if (!isEmpty(appDetails.rejectionReasons)) {
      return `Rejected by: ${appDetails.rejectionReasons.join(" ")}`;
    }

    if (!isEmpty(appDetails.deletionReasons)) {
      return `Deleted by: ${appDetails.deletionReasons.join(" ")}`;
    }

    return appDetails.transformedRecord;
  };

  const transformationBuilderView = () => {
    return (
      <>
        <div className="col-2">
          <FieldNavigationPanel />
        </div>

        <div className="col-10">
          <div className="row gy-4">
            <div className={rawRecordClasses}>
              <div className="card">
                <div className="card-body">
                  <RawDataBody clickToggleSection={clickToggleSection} />
                </div>
              </div>
            </div>

            <div className={transformedRecordClasses}>
              <div className="card">
                <div className="card-body">
                  <div className="d-flex flex-row flex-nowrap justify-content-between mb-4">
                    <h5 className="text-truncate">Transformed</h5>

                    <button
                      onClick={() =>
                        clickToggleSection("transformedRecordExpanded")
                      }
                      type="button"
                      className="btn btn-outline-primary"
                    >
                      <ExpandCollapseIcon
                        expanded={uiAppDetails["transformedRecordExpanded"]}
                      />
                    </button>
                  </div>

                  <RecordViewer record={transformedRecord()} format="JSON" />
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
      </>
    );
  };

  return (
    <div className="row">
      <HeaderActions />
      <NavTabs />
      <SharedDefinitionsModal pipelineId={appDetails.pipeline.id} />

      {!uiAppDetails.sharedDefinitionsTabActive && transformationBuilderView()}
      {uiAppDetails.sharedDefinitionsTabActive && (
        <SharedDefinitionsView
          definitionType="transformation"
        />
      )}
    </div>
  );
};

export default TransformationApp;
