import React from "react";
import { createPortal } from "react-dom";
import { useSelector, useDispatch } from "react-redux";
import classNames from "classnames";

import { selectUiAppDetails } from "~/js/features/TransformationApp/UiAppDetailsSlice";
import { selectAllSharedDefinitions } from "~/js/features/SharedDefinitionsSlice";

import {
  toggleSharedDefinitionsTab
} from "~/js/features/TransformationApp/UiAppDetailsSlice";

const NavTabs = () => {
  const dispatch = useDispatch();
  const uiAppDetails = useSelector(selectUiAppDetails);
  const sharedDefinitions = useSelector(selectAllSharedDefinitions);

  const transformationClasses = classNames("nav-link", {
    active: uiAppDetails.sharedDefinitionsTabActive == false,
  });

  const sharedDefinitionClasses = classNames("nav-link", {
    active: uiAppDetails.sharedDefinitionsTabActive == true,
  });

  return createPortal(
    <>
      <ul className="nav nav-tabs mt-4" role="tablist">
        <li
          className="nav-item"
          role="presentation"
        >
          <button className={transformationClasses} type="button" role="tab" onClick={ () => dispatch(toggleSharedDefinitionsTab(false))}>
            Transformation
          </button>
        </li>

        <li
          className="nav-item"
          role="presentation"
        >
          <button className={sharedDefinitionClasses} type="button" role="tab" onClick={ () => dispatch(toggleSharedDefinitionsTab(true))}>
            Shared Definitions ({ sharedDefinitions.length})
          </button>
        </li>
      </ul>
    </>,
    document.getElementById("react-nav-tabs")
  );
};

export default NavTabs;
