import { createSlice } from "@reduxjs/toolkit";

const rawRecordSlice = createSlice({
  name: "rawRecordSlice",
  initialState: {},
  reducers: {},
});

const { actions, reducer } = rawRecordSlice;

export const selectRawRecord = (state) => state.entities.rawRecord;

export const {} = actions;

export default reducer;
