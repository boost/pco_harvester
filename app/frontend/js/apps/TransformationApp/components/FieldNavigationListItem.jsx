import React from "react";
import { useDispatch, useSelector } from "react-redux";
import { selectFieldById } from "~/js/features/FieldsSlice";
import {
  selectUiFieldById,
  toggleDisplayField,
} from "~/js/features/UiFieldsSlice";
import classNames from "classnames";

const FieldNavigationListItem = ({ id }) => {
  const dispatch = useDispatch();
  const { name } = useSelector((state) => selectFieldById(state, id));
  const { error, displayed } = useSelector((state) =>
    selectUiFieldById(state, id)
  );

  const linkClasses = classNames("nav-link", {
    error: error,
  });

  return (
    <li className="nav-item">
      <a
        className={linkClasses}
        data-bs-toggle="collapse"
        onClick={() =>
          dispatch(toggleDisplayField({ id: id, displayed: !displayed }))
        }
        href={`#field-${id}`}
        role="button"
        aria-expanded={displayed}
        aria-controls={`field-${id}`}
      >
        {name || "New field"}{" "}
        {error && (
          <i className="bi bi-exclamation-circle-fill" aria-label="error"></i>
        )}
      </a>
    </li>
  );
};

export default FieldNavigationListItem;
