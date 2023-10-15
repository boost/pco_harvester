import React from "react";

import { useSelector } from "react-redux";
import { selectParameterById } from "~/js/features/ExtractionApp/ParametersSlice";
import { selectRequestById } from "~/js/features/ExtractionApp/RequestsSlice";
import { selectUiAppDetails } from "~/js/features/ExtractionApp/UiAppDetailsSlice";

const RequestFragment = ({ id, index }) => {
  const uiAppDetails = useSelector(selectUiAppDetails);

  const { name, content, kind } = useSelector((state) =>
    selectParameterById(state, id)
  );

  const { base_url } = useSelector((state) =>
    selectRequestById(state, uiAppDetails.activeRequest)
  );

  const prefix = () => {
    if (kind == "slug") {
      return "/";
    }

    if (index == 0 && !base_url.includes("?")) {
      return "?";
    }

    return "&";
  };

  const value = () => {
    if (kind == "slug") {
      return content;
    }

    if (name == "" || content == "") {
      return "";
    }

    return `${name}=${content}`;
  };

  return (
    <span>
      {prefix()}
      {value()}
    </span>
  );
};

export default RequestFragment;
