import { combineReducers, configureStore } from "@reduxjs/toolkit";

// entities

import fields from "/js/features/FieldsSlice";
import appDetails from "/js/features/AppDetailsSlice";

// ui

import uiFields from "/js/features/UiFieldsSlice";

export default function configureAppStore(preloadedState) {
  const store = configureStore({
    reducer: combineReducers({
      entities: combineReducers({
        fields,
        appDetails,
      }),
      ui: combineReducers({
        fields: uiFields,
      }),
    }),
    middleware: (getDefaultMiddleware) => getDefaultMiddleware(),
    preloadedState,
  });

  return store;
}
