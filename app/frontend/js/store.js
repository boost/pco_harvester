import { combineReducers, configureStore } from "@reduxjs/toolkit";

// entities

import rawRecord from '~/js/features/RawRecordSlice';
import transformedRecord from '~/js/features/TransformedRecordSlice';
import fields            from '~/js/features/FieldsSlice';

export default function configureAppStore(preloadedState) {
  const store = configureStore({
    reducer: combineReducers({
      entities: combineReducers({
        rawRecord,
        transformedRecord,
        fields
      }),
    }),
    middleware: (getDefaultMiddleware) => getDefaultMiddleware(),
    preloadedState,
  });

  return store;
}