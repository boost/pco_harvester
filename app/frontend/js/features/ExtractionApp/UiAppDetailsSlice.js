import { createSlice } from "@reduxjs/toolkit";

const uiAppDetailsSlice = createSlice({
  name: "appDetailsSlice",
  initialState: {},
  reducers: {},
});

const { actions, reducer } = uiAppDetailsSlice;

export const selectUiAppDetails = (state) => state.ui.appDetails;

export const {} = actions;

export default reducer;
