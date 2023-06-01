import React from "react";
import { useSelector } from "react-redux";
import { selectAllFields } from "~/js/features/FieldsSlice";

const NavigationPanel = () => {
  const fields = useSelector(selectAllFields);

  return (
    <ul id="field-list" className="nav flex-column overflow-auto flex-nowrap">
      {fields.map((field) => {
        return (
          <li className="nav-item" key={field.id}>
            <a className="nav-link p-1" href={`#field-${field.id}`}>
              {field.name || "New Field"}
            </a>
          </li>
        );
      })}
    </ul>
  );
};

export default NavigationPanel;
