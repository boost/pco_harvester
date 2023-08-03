import { createSlice, createEntityAdapter } from "@reduxjs/toolkit";

import { previewRequest } from "./RequestsSlice";

const uiRequestsAdapter = createEntityAdapter();

const uiRequestsSlice = createSlice({
  name: "requestsSlice",
  initialState: {},
  reducers: {},
  extraReducers: (builder) => {
    builder
      .addCase(previewRequest.pending, (state, action) => {
        uiRequestsAdapter.updateOne(state, {
          id: action.meta.arg.id,
          changes: { loading: true },
        });
      })
      .addCase(previewRequest.fulfilled, (state, action) => {
        uiRequestsAdapter.updateOne(state, {
          id: action.meta.arg.id,
          changes: { loading: false },
        });
      })
  },
});

const { actions, reducer } = uiRequestsSlice;

export const {
  selectById: selectUiRequestById,
  selectIds: selectUiRequestIds,
  selectAll: selectAllUiRequests,
} = uiRequestsAdapter.getSelectors((state) => state.ui.requests);

export const {} = actions;

export default reducer;
