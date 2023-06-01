import React from "react";
import { useSelector } from "react-redux";
import { selectFieldById } from "~/js/features/FieldsSlice";
import { selectUiFieldById } from "~/js/features/UiFieldsSlice";
import classNames from "classnames";

const FieldNavigationListItem = ({id}) => {
  
  const { name } = useSelector((state) => selectFieldById(state, id));
  const { error } = useSelector((state) => selectUiFieldById(state, id));

  const linkClasses  = classNames('nav-link', {
    'error': error
  });
  
  return(
    <li className="nav-item">
      <a
        className={ linkClasses }
        data-bs-toggle="collapse"
        href={`#field-${id}`}
        role="button"
        aria-expanded="false"
        aria-controls={`field-${id}`}
      >
        {name || "New field"}
        { " " }
        { error && <i className="bi bi-exclamation-circle-fill" aria-label="error"></i> }
      </a>
    </li>
  );
}

export default FieldNavigationListItem;


