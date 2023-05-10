import { combineReducers, configureStore } from "@reduxjs/toolkit";

// entities

import fields from "/js/features/FieldsSlice";
import appDetails from "/js/features/AppDetailsSlice";

// ui

import uiFields from "/js/features/UiFieldsSlice";
import uiAppDetails from "/js/features/UiAppDetailsSlice";

export default function configureAppStore(preloadedState) {
  const store = configureStore({
    reducer: combineReducers({
      entities: combineReducers({
        fields,
        appDetails,
      }),
      ui: combineReducers({
        fields: uiFields,
        appDetails: uiAppDetails
      }),
    }),
    middleware: (getDefaultMiddleware) => getDefaultMiddleware(),
    preloadedState,
  });

  return store;
}
