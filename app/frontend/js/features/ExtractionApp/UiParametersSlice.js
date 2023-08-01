
import { createSlice, createEntityAdapter } from "@reduxjs/toolkit";

import { addParameter, updateParameter } from "./ParametersSlice";

const uiParametersAdapter = createEntityAdapter();

const uiParametersSlice = createSlice({
  name: "parametersSlice",
  initialState: {},
  reducers: {
    toggleDisplayParameter(state, action) {
      uiParametersAdapter.updateOne(state, {
        id: action.payload.id,
        changes: { displayed: action.payload.displayed },
      });
    },
    toggleDisplayParameters(state, action) {
      const { parameters, displayed } = action.payload;

      uiParametersAdapter.updateMany(
        state,
        parameters.map((parameter) => {
          return { id: parameter.id, changes: { displayed: displayed } };
        })
      );
    }
  },
  extraReducers: (builder) => {
    builder
      .addCase(addParameter.fulfilled, (state, action) => {
        uiParametersAdapter.upsertOne(state, {
          id: action.payload.id,
          saved: true,
          deleting: false,
          saving: false,
          expanded: true,
          displayed: true,
        });
      })
      .addCase(updateParameter.pending, (state, action) => {
        uiParametersAdapter.updateOne(state, {
          id: action.meta.arg.id,
          changes: { saving: true, hasRun: false },
        });
      })
      .addCase(updateParameter.fulfilled, (state, action) => {
        uiParametersAdapter.updateOne(state, {
          id: action.meta.arg.id,
          changes: { saving: false },
        });
      })
  },
});

const { actions, reducer } = uiParametersSlice;

export const {
  selectById: selectUiParameterById,
  selectIds: selectUiParameterIds,
  selectAll: selectAllUiParameters,
} = uiParametersAdapter.getSelectors((state) => state.ui.parameters);

export const selectDisplayedParameterIds = (state) => {
  return selectAllUiParameters(state)
    .filter((parameter) => parameter.displayed)
    .map((parameter) => parameter.id);
};

export const { toggleDisplayParameter, toggleDisplayParameters } = actions;

export default reducer;
