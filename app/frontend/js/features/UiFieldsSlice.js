import { createSlice, createEntityAdapter } from "@reduxjs/toolkit";

import { addField, deleteField, updateField } from "./FieldsSlice";
import { clickedOnRunFields } from "./AppDetailsSlice";

const uiFieldsAdapter = createEntityAdapter();

const uiFieldsSlice = createSlice({
  name: "fieldsSlice",
  initialState: {},
  reducers: {
    toggleCollapseField(state, action) {
      uiFieldsAdapter.updateOne(state, {
        id: action.payload.id,
        changes: { expanded: action.payload.expanded },
      });
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(addField.fulfilled, (state, action) => {
        uiFieldsAdapter.upsertOne(state, {
          id: action.payload.id,
          saved: true,
          deleting: false,
          saving: false,
          running: false,
          hasRun: false,
        });
      })
      .addCase(clickedOnRunFields.pending, (state, action) => {
        uiFieldsAdapter.updateMany(
          state,
          action.meta.arg.fields.map((id) => {
            return { id: id, changes: { running: true, error: false } };
          })
        );
      })
      .addCase(clickedOnRunFields.rejected, (state, action) => {
        uiFieldsAdapter.updateMany(
          state,
          action.meta.arg.fields.map((id) => {
            return {
              id: id,
              changes: {
                hasRun: true,
                running: false,
                error: {
                  title: "Error",
                  description:
                    "Something unexpected outside of your code happened. Let the developers know.",
                },
              },
            };
          })
        );
      })
      .addCase(clickedOnRunFields.fulfilled, (state, action) => {
        uiFieldsAdapter.updateMany(
          state,
          action.meta.arg.fields.map((id) => {
            return {
              id: id,
              changes: {
                running: false,
                error: action.payload.errors[id],
                hasRun: true,
              },
            };
          })
        );
      })
      .addCase(updateField.pending, (state, action) => {
        uiFieldsAdapter.updateOne(state, {
          id: action.meta.arg.id,
          changes: { saving: true, error: false, hasRun: false },
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

export const { toggleCollapseField } = actions;

export default reducer;
