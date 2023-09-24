import { createSlice } from "@reduxjs/toolkit";

const uiAppDetailsSlice = createSlice({
  name: "appDetailsSlice",
  initialState: {},
  reducers: {
    toggleSection(state, action) {
      const sectionName = action.payload.sectionName;

      state[sectionName] = !state[sectionName];
    },
    toggleSharedDefinitionsTab(state, action) {
      state.sharedDefinitionsTabActive = action.payload;
    },
  },
});

const { actions, reducer } = uiAppDetailsSlice;

export const selectUiAppDetails = (state) => state.ui.appDetails;

export const { toggleSection, toggleSharedDefinitionsTab } = actions;

export default reducer;
