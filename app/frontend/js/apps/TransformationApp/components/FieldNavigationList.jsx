import React from "react";
import { useSelector } from "react-redux";
import { selectFieldIds } from "~/js/features/FieldsSlice";
import FieldNavigationListItem from "./FieldNavigationListItem";

const FieldNavigationList = () => {
  const fieldIds = useSelector(selectFieldIds);

  return (
    <ul className="field-nav nav nav-pills flex-column overflow-auto flex-nowrap">
      {fieldIds.map((id) => {
        return (
          <FieldNavigationListItem id={id} key={id} />
        );
      })}
    </ul>
  );
};

export default FieldNavigationList;
