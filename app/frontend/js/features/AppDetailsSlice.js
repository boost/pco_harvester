import { createAsyncThunk, createSlice } from "@reduxjs/toolkit";
import { request } from "~/js/utils/request";
import { askNewRawRecord } from "./RawRecordSlice";

export const clickedOnRunFields = createAsyncThunk(
  "appDetails/clickedOnRunFieldsStatus",
  async (payload) => {
    const {
      pipelineId,
      harvestDefinitionId,
      transformationDefinitionId,
      fields,
      page,
      record,
    } = payload;

    const response = request
      .post(
        `/pipelines/${pipelineId}/harvest_definitions/${harvestDefinitionId}/transformation_definitions/${transformationDefinitionId}/fields/run`,
        {
          page: page,
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
    builder
      .addCase(clickedOnRunFields.fulfilled, (state, action) => {
        state.transformedRecord = action.payload.transformed_record;
      })
      .addCase(askNewRawRecord.fulfilled, (state, action) => {
        state.transformedRecord =
          action.payload.transformedRecord.transformed_record;
      });
  },
});

export const selectAppDetails = (state) => state.entities.appDetails;

const { actions, reducer } = AppDetailsSlice;

export default reducer;
