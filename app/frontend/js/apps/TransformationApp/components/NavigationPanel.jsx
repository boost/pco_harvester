import React from "react";
import { useSelector } from "react-redux";
import { selectAllFields } from "~/js/features/FieldsSlice";
import { Collapse } from "bootstrap";

const NavigationPanel = () => {
  const fields = useSelector(selectAllFields);

  return (
    <ul id="simple-list-example" className="nav flex-column">
      {fields.map((field) => {
        return (
          <li className="nav-item" key={field.id}>
            <a
              href={`#accordion-field-${field.id}`}
              // data-bs-toggle="collapse"
              // data-bs-target={`#field-${field.id}`}
              // aria-expanded="false"
              // aria-controls={`#field-${field.id}`}
            >
              {field.name}
            </a>
          </li>
        );
      })}
    </ul>
  );
};

export default NavigationPanel;
