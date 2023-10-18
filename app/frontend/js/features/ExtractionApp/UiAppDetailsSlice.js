import { createSlice } from "@reduxjs/toolkit";

const uiAppDetailsSlice = createSlice({
  name: "appDetailsSlice",
  initialState: {},
  reducers: {
    updateActiveRequest(state, action) {
      state.activeRequest = action.payload;
      state.sharedDefinitionsTabActive = false;
    },
    activateSharedDefinitionsTab(state) {
      state.activeRequest = 0;
      state.sharedDefinitionsTabActive = true;
    },
    setCurrentPage(state, action) {
      state.currentPage = action.payload;
    },
    setCurrentRecord(state, action) {
      state.currentRecord = action.payload;
    }
  },
});

const { actions, reducer } = uiAppDetailsSlice;

export const selectUiAppDetails = (state) => state.ui.appDetails;

export const { updateActiveRequest, activateSharedDefinitionsTab, setCurrentPage, setCurrentRecord } = actions;

export default reducer;
