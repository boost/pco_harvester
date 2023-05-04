import { createSlice } from "@reduxjs/toolkit";

const rawRecordSlice = createSlice({
  name: "rawRecord",
  initialState: {},
  reducers: {},
});

export const selectRawRecord = (state) => state.entities.rawRecord;

const { reducer } = rawRecordSlice;

export default reducer;

