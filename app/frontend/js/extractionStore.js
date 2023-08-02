import { combineReducers, configureStore } from "@reduxjs/toolkit";

// entities

import parameters from "/js/features/ExtractionApp/ParametersSlice";
import appDetails from "/js/features/ExtractionApp/AppDetailsSlice";
import requests   from "/js/features/ExtractionApp/RequestsSlice";

// ui

import uiParameters from "/js/features/ExtractionApp/UiParametersSlice";

// config
import config from "/js/features/ConfigSlice";

export default function configureAppStore(preloadedState) {
  const store = configureStore({
    reducer: combineReducers({
      entities: combineReducers({
        requests,
        parameters,
        appDetails
      }),
      ui: combineReducers({
        parameters: uiParameters
      }),
      config,
    }),
    preloadedState,
  });

  return store;
}
