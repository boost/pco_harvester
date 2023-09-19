import { createSlice } from "@reduxjs/toolkit";

const uiAppDetailsSlice = createSlice({
  name: "appDetailsSlice",
  initialState: {},
  reducers: {
    updateActiveRequest(state, action) {
      state.activeRequest = action.payload;
      state.sharedTabActive = false;
    },
    activateSharedTab(state, action) {
      state.activeRequest = 0;
      state.sharedTabActive = true;
    }
  },
});

const { actions, reducer } = uiAppDetailsSlice;

export const selectUiAppDetails = (state) => state.ui.appDetails;

export const { updateActiveRequest, activateSharedTab } = actions;

export default reducer;
