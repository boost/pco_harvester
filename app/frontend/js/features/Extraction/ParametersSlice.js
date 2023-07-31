import {
  createAsyncThunk,
  createSlice,
  createEntityAdapter,
} from "@reduxjs/toolkit";
import { request } from "~/js/utils/request";

const parametersAdapter = createEntityAdapter({
  sortComparer: (parameterOne, parameterTwo) => parameterTwo.created_at.localeCompare(parameterOne.created_at),
});

const parametersSlice = createSlice({
  name: "parametersSlice",
  initialState: {},
  reducers: {},
  extraReducers: (builder) => {},
});

const { actions, reducer } = parametersSlice;

export const {
  selectById: selectFieldById,
  selectIds: selectFieldIds,
  selectAll: selectAllparameters,
} = parametersAdapter.getSelectors((state) => state.entities.parameters);

export const {} = actions;

export default reducer;
