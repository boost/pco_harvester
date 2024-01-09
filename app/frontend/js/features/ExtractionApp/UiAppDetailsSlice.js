import { createSlice } from "@reduxjs/toolkit";

const uiAppDetailsSlice = createSlice({
  name: "appDetailsSlice",
  initialState: {},
  reducers: {
    updateActiveRequest(state, action) {
      state.activeRequest = action.payload;
      state.sharedDefinitionsTabActive = false;
      state.stopConditionsTabActive = false;
    },
    activateSharedDefinitionsTab(state) {
      state.activeRequest = 0;
      state.sharedDefinitionsTabActive = true;
      state.stopConditionsTabActive = false;
    },
    activateStopConditionsTab(state) {
      state.activeRequest = 0;
      state.sharedDefinitionsTabActive = false;
      state.stopConditionsTabActive = true;
    },
  },
});

const { actions, reducer } = uiAppDetailsSlice;

export const selectUiAppDetails = (state) => state.ui.appDetails;

export const {
  updateActiveRequest,
  activateSharedDefinitionsTab,
  activateStopConditionsTab,
} = actions;

export default reducer;
