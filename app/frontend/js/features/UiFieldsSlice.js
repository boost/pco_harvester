import { createSlice, createEntityAdapter } from "@reduxjs/toolkit";

import { updateField } from "./FieldsSlice";
import { clickedOnRunAttributes } from "./AppDetailsSlice";

const uiFieldsAdapter = createEntityAdapter();

const uiFieldsSlice = createSlice({
  name: "fieldsSlice",
  initialState: {},
  reducers: {},
  extraReducers: (builder) => {
    builder
      .addCase(clickedOnRunAttributes.pending, (state, action) => {
        uiFieldsAdapter.updateMany(
          state,
          action.meta.arg.fields.map((id) => {
            return { id: id, changes: { running: true } };
          })
        );
      })
      .addCase(clickedOnRunAttributes.fulfilled, (state, action) => {
        uiFieldsAdapter.updateMany(
          state,
          action.meta.arg.fields.map((id) => {
            return { id: id, changes: { running: false } };
          })
        );
      })
      .addCase(updateField.pending, (state, action) => {
        uiFieldsAdapter.updateOne(state, {
          id: action.meta.arg.id,
          changes: { saving: true },
        });
      })
      .addCase(updateField.fulfilled, (state, action) => {
        uiFieldsAdapter.updateOne(state, {
          id: action.meta.arg.id,
          changes: { saving: false },
        });
      });
  },
});

const { actions, reducer } = uiFieldsSlice;

export const {
  selectById: selectUiFieldById,
  selectIds: selectUiFieldIds,
  selectAll: selectAllUiFields,
} = uiFieldsAdapter.getSelectors((state) => state.ui.fields);

export const {} = actions;

export default reducer;
