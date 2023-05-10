import { combineReducers, configureStore } from "@reduxjs/toolkit";

// entities
import fields from "/js/features/FieldsSlice";
import appDetails from "/js/features/AppDetailsSlice";

// ui
import uiFields from "/js/features/UiFieldsSlice";
import uiAppDetails from "/js/features/UiAppDetailsSlice";

// ui
import config from "/js/features/ConfigSlice";

export default function configureAppStore(preloadedState) {
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
    middleware: (getDefaultMiddleware) => getDefaultMiddleware(),
    preloadedState,
  });

  return store;
}
