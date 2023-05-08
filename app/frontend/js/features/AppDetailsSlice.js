import { createAsyncThunk, createSlice } from "@reduxjs/toolkit";
import { request } from "/js/utils/request";

export const clickedOnRunAttributes = createAsyncThunk(
  "appDetails/clickedOnRunAttributesStatus",
  async (payload) => {
    const { contentPartnerId, transformationDefinitionId, fields, record } =
      payload;

    const response = request
      .post(
        `/content_partners/${contentPartnerId}/transformation_definitions/${transformationDefinitionId}/fields/run`,
        {
          record: record,
          fields: fields,
        }
      )
      .then((response) => {
        return response.data;
      });

    return response;
  }
);

const AppDetailsSlice = createSlice({
  name: "appDetails",
  initialState: {},
  reducers: {},
  extraReducers: (builder) => {
    builder.addCase(clickedOnRunAttributes.fulfilled, (state, action) => {
      state.transformedRecord = action.payload;
    });
  },
});

export const selectAppDetails = (state) => state.entities.appDetails;

const { actions, reducer } = AppDetailsSlice;

export default reducer;
