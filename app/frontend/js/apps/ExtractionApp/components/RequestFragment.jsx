import React from "react";

import { useSelector } from "react-redux";
import { selectParameterById } from "~/js/features/ExtractionApp/ParametersSlice";

const RequestFragment = ({ id, index }) => {
  const { name, content, kind } = useSelector((state) =>
    selectParameterById(state, id)
  );

  const prefix = () => {
    if (kind == "slug") {
      return "/";
    }

    if (index == 0) {
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
