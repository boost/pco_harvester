import { combineReducers, configureStore } from "@reduxjs/toolkit";
import {
  displayedFieldsListener,
  loadDisplayedFields,
} from "./displayedFieldsListener";

// entities
import fields from "/js/features/FieldsSlice";
import appDetails from "/js/features/AppDetailsSlice";

// ui
import uiFields from "/js/features/UiFieldsSlice";
import uiAppDetails from "/js/features/UiAppDetailsSlice";

// config
import config from "/js/features/ConfigSlice";

export default function configureAppStore(preloadedState) {
  loadDisplayedFields(preloadedState);

  const store = configureStore({
    reducer: combineReducers({
      entities: combineReducers({
        fields,
        appDetails,
      }),
      ui: combineReducers({
        fields: uiFields,
        appDetails: uiAppDetails,
      }),
      config,
    }),
    middleware: (getDefaultMiddleware) =>
      getDefaultMiddleware().concat(displayedFieldsListener.middleware),
    preloadedState,
  });

  return store;
}
