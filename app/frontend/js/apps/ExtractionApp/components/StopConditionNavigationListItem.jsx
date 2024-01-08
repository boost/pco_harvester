import React from "react";
import { useDispatch, useSelector } from "react-redux";
import { selectStopConditionById } from "~/js/features/ExtractionApp/StopConditionsSlice";
import {
  selectUiStopConditionById,
  toggleDisplayStopCondition,
  setActiveStopCondition,
} from "~/js/features/ExtractionApp/UiStopConditionsSlice";

const StopConditionNavigationListItem = ({ id }) => {
  const dispatch = useDispatch();
  const { name } = useSelector((state) => selectStopConditionById(state, id));
  const { displayed } = useSelector((state) =>
    selectUiStopConditionById(state, id)
  );

  const handleListItemClick = () => {
    const desiredDisplaySetting = !displayed;

    dispatch(
      toggleDisplayStopCondition({ id: id, displayed: desiredDisplaySetting })
    );

    if (desiredDisplaySetting == true) {
      dispatch(setActiveStopCondition(id));
    }
  };

  return (
    <li className="nav-item">
      <a
        className="nav-link text-truncate"
        data-bs-toggle="collapse"
        onClick={() => handleListItemClick()}
        href={`#parameter-${id}`}
        role="button"
        aria-expanded={displayed}
        aria-controls={`parameter-${id}`}
      >
        {name || `New `}{" "}
      </a>
    </li>
  );
};

export default StopConditionNavigationListItem;
