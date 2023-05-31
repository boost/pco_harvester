import { createAsyncThunk, createSlice } from "@reduxjs/toolkit";
import { request } from "~/js/utils/request";

export const clickedOnRunFields = createAsyncThunk(
  "appDetails/clickedOnRunFieldsStatus",
  async (payload) => {
    const { contentSourceId, transformationDefinitionId, fields, record } =
      payload;

    const response = request
      .post(
        `/content_sources/${contentSourceId}/transformation_definitions/${transformationDefinitionId}/fields/run`,
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
    builder.addCase(clickedOnRunFields.fulfilled, (state, action) => {
      state.transformedRecord = action.payload.transformed_record;
    });
  },
});

export const selectAppDetails = (state) => state.entities.appDetails;

const { actions, reducer } = AppDetailsSlice;

export default reducer;
