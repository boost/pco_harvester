import { createSlice, createEntityAdapter } from "@reduxjs/toolkit";

import { addField, deleteField, updateField } from "./FieldsSlice";
import { clickedOnRunFields } from "./AppDetailsSlice";

const uiFieldsAdapter = createEntityAdapter();

const uiFieldsSlice = createSlice({
  name: "fieldsSlice",
  initialState: {},
  reducers: {},
  extraReducers: (builder) => {
    builder
      .addCase(addField.fulfilled, (state, action) => {
        uiFieldsAdapter.upsertOne(state, {
          id: action.payload.id,
          saved: true,
          deleting: false,
          saving: false,
          running: false,
        });
      })
      .addCase(clickedOnRunFields.pending, (state, action) => {
        uiFieldsAdapter.updateMany(
          state,
          action.meta.arg.fields.map((id) => {
            return { id: id, changes: { running: true } };
          })
        );
      })
      .addCase(clickedOnRunFields.fulfilled, (state, action) => {
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
      })
      .addCase(deleteField.pending, (state, action) => {
        uiFieldsAdapter.updateOne(state, {
          id: action.meta.arg.id,
          changes: { deleting: true },
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
