import { createSlice } from "@reduxjs/toolkit";

const contentPartnerSlice = createSlice({
  name: "contentPartner",
  initialState: {},
  reducers: {},
});

export const selectContentPartner = (state) => state.entities.contentPartner;

const { reducer } = contentPartnerSlice;

export default reducer;
