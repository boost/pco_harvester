import { combineReducers, configureStore } from "@reduxjs/toolkit";

// entities

import parameters from "/js/features/ExtractionApp/ParametersSlice";
import appDetails from "/js/features/ExtractionApp/AppDetailsSlice";
import requests from "/js/features/ExtractionApp/RequestsSlice";
import stopConditions from '/js/features/ExtractionApp/StopConditionsSlice';

// ui

import uiParameters from "/js/features/ExtractionApp/UiParametersSlice";
import uiRequests from "/js/features/ExtractionApp/UiRequestsSlice";
import uiAppDetails from "/js/features/ExtractionApp/UiAppDetailsSlice";
import uiStopConditions from '/js/features/ExtractionApp/UiStopConditionsSlice';

// config
import config from "/js/features/ConfigSlice";
import sharedDefinitions from "/js/features/SharedDefinitionsSlice";

export default function configureAppStore(preloadedState) {
  const store = configureStore({
    reducer: combineReducers({
      entities: combineReducers({
        requests,
        parameters,
        appDetails,
        sharedDefinitions,
        stopConditions
      }),
      ui: combineReducers({
        parameters: uiParameters,
        requests: uiRequests,
        appDetails: uiAppDetails,
        stopConditions: uiStopConditions
      }),
      config,
    }),
    preloadedState,
  });

  return store;
}
