import { createSlice } from "@reduxjs/toolkit";

const fieldsSlice = createSlice({
  name: "fieldsSlice",
  initialState: {},
  reducers: {},
});

export const selectFields = (state) => state.entities.fields;

const { reducer } = fieldsSlice;

export default reducer;

