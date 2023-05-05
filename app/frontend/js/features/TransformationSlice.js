import { createSlice } from "@reduxjs/toolkit";

const transformationSlice = createSlice({
  name: "transformation",
  initialState: {},
  reducers: {},
});

export const selectTransformation = (state) => state.entities.transformation;

const { reducer } = transformationSlice;

export default reducer;


