import { createSlice } from "@reduxjs/toolkit";
import { clickedOnRunFields } from "./AppDetailsSlice";

const rawRecordSlice = createSlice({
  name: "rawRecordSlice",
  initialState: {},
  reducers: {},
  extraReducers: (builder) => {
    builder
      .addCase(clickedOnRunFields.pending, (state) => {
        state.isFetching = true;
        state.error = null;
      })
      .addCase(clickedOnRunFields.fulfilled, (state, action) => {
        state.isFetching = false;
        state.error = null;
        state.page = action.payload.rawRecordSlice.page;
        state.record = action.payload.rawRecordSlice.record;
        state.body = action.payload.rawRecordSlice.body;

        window.history.replaceState(
          null,
          null,
          `${window.location.pathname}?page=${state.page}&record=${state.record}`
        );
      })
      .addCase(clickedOnRunFields.rejected, (state, action) => {
        state.isFetching = false;
        state.error = "An error occured fetching the raw record.";
      });
  },
});

const { actions, reducer } = rawRecordSlice;

export const selectRawRecord = (state) => state.entities.rawRecord;

export const {} = actions;

export default reducer;
