import { createListenerMiddleware } from "@reduxjs/toolkit";
import {
  selectAllUiFields,
  selectDisplayedFieldIds,
  toggleDisplayField,
} from "./features/TransformationApp/UiFieldsSlice";

export const loadDisplayedFields = (state) => {
  let stateUiFields = selectAllUiFields(state);
  let displayedFieldIds = JSON.parse(
    localStorage.getItem("displayedFieldIds") || "[]"
  );
  if (displayedFieldIds.length === 0 && stateUiFields.length > 0) {
    displayedFieldIds = [stateUiFields[0].id];
  }

  stateUiFields.forEach((field) => {
    if (displayedFieldIds.find((id) => id === field.id)) {
      field.displayed = true;
    }
  });
};

export const displayedFieldsListener = createListenerMiddleware();

displayedFieldsListener.startListening({
  actionCreator: toggleDisplayField,
  effect: (_action, listenerApi) => {
    localStorage.setItem(
      "displayedFieldIds",
      JSON.stringify(selectDisplayedFieldIds(listenerApi.getState()))
    );
  },
});
