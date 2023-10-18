import React from "react";
import { useSelector } from "react-redux";
import { selectParameterIdsByRequestAndKind } from "/js/features/ExtractionApp/ParametersSlice";
import ParameterNavigationListItem from "./ParameterNavigationListItem";

const ParameterNavigationList = ({ requestId, kind }) => {
  const ids = useSelector((state) =>
    selectParameterIdsByRequestAndKind(state, requestId, kind)
  );

  return ids.map((id) => <ParameterNavigationListItem id={id} key={id} />);
};

export default ParameterNavigationList;
