import { combineReducers, configureStore } from "@reduxjs/toolkit";

// entities

import parameters from "/js/features/extraction/ParametersSlice";

// config
import config from "/js/features/ConfigSlice";

export default function configureAppStore(preloadedState) {
  const store = configureStore({
    reducer: combineReducers({
      entities: combineReducers({
        parameters
      }),
      ui: combineReducers({}),
      config,
    }),
    preloadedState,
  });

  return store;
}
