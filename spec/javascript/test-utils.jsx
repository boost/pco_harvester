import React from 'react'
import { render } from '@testing-library/react'
import { configureStore, combineReducers } from '@reduxjs/toolkit'
import { Provider } from 'react-redux'

// entities

import fields from "~/js/features/FieldsSlice";
import appDetails from '~/js/features/AppDetailsSlice';

// ui

import uiFields from "~/js/features/UiFieldsSlice";
import uiAppDetails from "~/js/features/UiAppDetailsSlice";

export function renderWithProviders(
  ui,
  {
    preloadedState,
    store = configureStore({
      reducer: combineReducers({
        entities: combineReducers({
          fields,
          appDetails,
        }),
        ui: combineReducers({
          fields: uiFields,
          appDetails: uiAppDetails,
        }),
      }),
      preloadedState,
    }),
    ...renderOptions
  } = {}
) {
  function Wrapper({ children }) {
    return <Provider store={store}>{children}</Provider>
  }

  // Return an object with the store and all of RTL's query functions
  return { store, ...render(ui, { wrapper: Wrapper, ...renderOptions }) }
}
