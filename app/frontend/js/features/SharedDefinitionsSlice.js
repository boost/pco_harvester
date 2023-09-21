import { createSlice, createEntityAdapter } from "@reduxjs/toolkit";

const sharedDefinitionsAdapter = createEntityAdapter({});

const SharedDefinitionsSlice = createSlice({
  name: "sharedDefinitions",
  initialState: {},
  reducers: {},
});

export const selectSharedDefinitions = (state) =>
  state.entities.sharedDefinitions;

const { actions, reducer } = SharedDefinitionsSlice;

export const { selectAll: selectAllSharedDefinitions } =
  sharedDefinitionsAdapter.getSelectors(
    (state) => state.entities.sharedDefinitions
  );

export default reducer;
