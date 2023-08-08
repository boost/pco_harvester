import { createListenerMiddleware, isAnyOf } from "@reduxjs/toolkit";
import {
  selectAllUiParameters,
  selectDisplayedParameterIds,
  toggleDisplayParameter,
} from "./features/ExtractionApp/UiParametersSlice";

export const loadDisplayedParameters = (state) => {
  let stateUiParameters = selectAllUiParameters(state);
  let displayedParameterIds = JSON.parse(
    localStorage.getItem("displayedParameterIds") || "[]"
  );
  if (displayedParameterIds.length === 0 && stateUiParameters.length > 0) {
    displayedParameterIds = [stateUiParameters[0].id];
  }

  stateUiParameters.forEach((parameter) => {
    if (displayedParameterIds.find((id) => id === parameter.id)) {
      parameter.displayed = true;
    }
  });
};

export const displayedParametersListener = createListenerMiddleware();
displayedParametersListener.startListening({
  actionCreator: toggleDisplayParameter,
  effect: (_action, listenerApi) => {
    localStorage.setItem(
      "displayedParameterIds",
      JSON.stringify(selectDisplayedParameterIds(listenerApi.getState()))
    );
  },
});
