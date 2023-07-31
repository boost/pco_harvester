import { combineReducers, configureStore } from "@reduxjs/toolkit";

// config
import config from "/js/features/ConfigSlice";

export default function configureAppStore(preloadedState) {
  const store = configureStore({
    reducer: combineReducers({
      entities: combineReducers({}),
      ui: combineReducers({}),
      config,
    }),
    preloadedState,
  });

  return store;
}
