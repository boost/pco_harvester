import { createSlice } from "@reduxjs/toolkit";

const appDetailsSlice = createSlice({
  name: "appDetails",
  initialState: {},
  reducers: {},
});

export const selectAppDetails = (state) => state.entities.appDetails;

const { reducer } = appDetailsSlice;

export default reducer;
