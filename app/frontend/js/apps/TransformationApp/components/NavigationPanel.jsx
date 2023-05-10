import React from "react";
import { useSelector } from "react-redux";
import { selectAllFields } from "~/js/features/FieldsSlice";
import { Collapse } from "bootstrap";

const NavigationPanel = () => {
  const fields = useSelector(selectAllFields);

  return (
    <div id="simple-list-example" className="d-flex flex-column gap-2 ">
      {fields.map((field) => {
        return (
          <a
            href={`#field-${field.id}`}
            key={field.id}
            className="p1"
          >
            { field.name || 'New Field' }
          </a>
        );
      })}
    </div>
  );
};

export default NavigationPanel;
