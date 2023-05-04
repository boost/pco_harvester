import { createSlice } from "@reduxjs/toolkit";

const transformedRecordSlice = createSlice({
  name: "transformedRecordSlice",
  initialState: {},
  reducers: {},
});

export const selectTransformedRecord = (state) => state.entities.transformedRecord;

const { reducer } = transformedRecordSlice;

export default reducer;

