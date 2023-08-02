import React from "react";
import { useDispatch, useSelector } from "react-redux";
import { selectParameterById } from "~/js/features/ExtractionApp/ParametersSlice";
import {
  selectUiParameterById,
  toggleDisplayParameter,
} from "~/js/features/ExtractionApp/UiParametersSlice";

const ParameterNavigationListItem = ({ id, index }) => {
  const dispatch = useDispatch();

  const { name, kind, content } = useSelector((state) => selectParameterById(state, id));
  const { displayed }  = useSelector((state) => selectUiParameterById(state, id));

  const displayName = () => {
    if(kind == 'slug') {
      return `Slug ${index + 1}`
    }

    return name;
  }

  return (
    <li className="nav-item">
      <a
        className="nav-link text-truncate"
        data-bs-toggle="collapse"
        onClick={() =>
          dispatch(toggleDisplayParameter({ id: id, displayed: !displayed }))
        }
        href={`#parameter-${id}`}
        role="button"
        aria-expanded={displayed}
        aria-controls={`parameter-${id}`}
      >
        {displayName() || `New `}{" "}
      </a>
    </li>
  );
};

export default ParameterNavigationListItem;
