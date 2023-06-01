import React from "react";
import { useSelector } from "react-redux";
import { selectAllFields } from "~/js/features/FieldsSlice";

const FieldNavigationList = () => {
  const fields = useSelector(selectAllFields);

  return (
    <ul className="field-nav nav nav-pills flex-column overflow-auto flex-nowrap">
      {fields.map((field) => {
        return (
          <li className="nav-item" key={field.id}>
            <a
              className="nav-link"
              data-bs-toggle="collapse"
              href={`#field-${field.id}`}
              role="button"
              aria-expanded="false"
              aria-controls={`field-${field.id}`}
            >
              {field.name || "New Field"}
            </a>
          </li>
        );
      })}
    </ul>
  );
};

export default FieldNavigationList;
