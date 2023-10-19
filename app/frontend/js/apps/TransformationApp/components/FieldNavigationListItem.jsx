import React from "react";
import { useDispatch, useSelector } from "react-redux";
import { selectFieldById } from "~/js/features/TransformationApp/FieldsSlice";
import {
  selectUiFieldById,
  toggleDisplayField,
  setActiveField
} from "~/js/features/TransformationApp/UiFieldsSlice";
import classNames from "classnames";

const FieldNavigationListItem = ({ id }) => {
  const dispatch = useDispatch();
  const { name, kind } = useSelector((state) => selectFieldById(state, id));
  const { error, displayed } = useSelector((state) =>
    selectUiFieldById(state, id)
  );

  const linkClasses = classNames("nav-link", "text-truncate", {
    error: error,
  });

  const placeholderListItemText = () => {
    if (kind == "field") {
      return "field";
    }

    return "condition";
  };

  const handleListItemClick = () => {
    const desiredDisplaySetting = !displayed;

    dispatch(toggleDisplayField({ id: id, displayed: desiredDisplaySetting }))

    if(desiredDisplaySetting == true) {
      dispatch(setActiveField(id))
    }
  }

  return (
    <li className="nav-item">
      <a
        className={linkClasses}
        data-bs-toggle="collapse"
        onClick={() => handleListItemClick()}
        href={`#field-${id}`}
        role="button"
        aria-expanded={displayed}
        aria-controls={`field-${id}`}
      >
        {name || `New ${placeholderListItemText()}`}{" "}
        {error && (
          <i className="bi bi-exclamation-circle-fill" aria-label="error"></i>
        )}
      </a>
    </li>
  );
};

export default FieldNavigationListItem;
