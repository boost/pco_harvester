import { createSlice, createEntityAdapter } from "@reduxjs/toolkit";

import { previewRequest } from "./RequestsSlice";

const uiRequestsAdapter = createEntityAdapter();

const uiRequestsSlice = createSlice({
  name: "requestsSlice",
  initialState: {},
  reducers: {
    setLoading(state, action) {
      uiRequestsAdapter.updateOne(state, {
        id: action.payload,
        changes: { loading: true },
      });
    },
  },
  extraReducers: (builder) => {
    builder
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

export const { setLoading } = actions;

export default reducer;
