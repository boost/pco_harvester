import { combineReducers, configureStore } from "@reduxjs/toolkit";

// entities

import fields            from '~/js/features/FieldsSlice';
import appDetails        from '~/js/features/AppDetailsSlice';


export default function configureAppStore(preloadedState) {
  const store = configureStore({
    reducer: combineReducers({
      entities: combineReducers({
        fields,
        appDetails
      }),
    }),
    middleware: (getDefaultMiddleware) => getDefaultMiddleware(),
    preloadedState,
  });

  return store;
}