import React from "react";
import { createPortal } from "react-dom";
import { useSelector, useDispatch } from "react-redux";
import classNames from "classnames";

import { selectRequestIds } from "~/js/features/ExtractionApp/RequestsSlice";
import { selectAllParameters } from "~/js/features/ExtractionApp/ParametersSlice";

import { toggleDisplayParameters } from "~/js/features/ExtractionApp/UiParametersSlice";

import {
  selectUiAppDetails,
  updateActiveRequest,
} from "~/js/features/ExtractionApp/UiAppDetailsSlice";

const NavTabs = () => {
  const dispatch = useDispatch();
  const uiAppDetails = useSelector(selectUiAppDetails);
  const requestIds = useSelector(selectRequestIds);
  const initialRequestId = requestIds[0];
  const mainRequestId = requestIds[1];

  const initialRequestClasses = classNames("nav-link", {
    active: uiAppDetails.activeRequest == initialRequestId,
  });
  const mainRequestClasses = classNames("nav-link", {
    active: uiAppDetails.activeRequest == mainRequestId,
  });
  const allParameters = useSelector(selectAllParameters);

  const handleTabClick = (id) => {
    dispatch(
      toggleDisplayParameters({ parameters: allParameters, displayed: true })
    );
    dispatch(updateActiveRequest(id));
  };

  return createPortal(
    <>
      <ul className="nav nav-tabs mt-4" role="tablist">
        <li className="nav-item" role="presentation">
          <button
            className={initialRequestClasses}
            type="button"
            role="tab"
            onClick={() => {
              handleTabClick(initialRequestId);
            }}
          >
            Initial Request
          </button>
        </li>

        <li
          className="nav-item"
          role="presentation"
          onClick={() => {
            handleTabClick(mainRequestId);
          }}
        >
          <button className={mainRequestClasses} type="button" role="tab">
            Main Request
          </button>
        </li>
      </ul>
    </>,
    document.getElementById("react-nav-tabs")
  );
};

export default NavTabs;
