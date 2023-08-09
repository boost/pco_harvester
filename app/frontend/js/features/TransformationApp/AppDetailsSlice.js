import { createAsyncThunk, createSlice } from "@reduxjs/toolkit";
import { request } from "~/js/utils/request";

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
    builder.addCase(clickedOnRunFields.fulfilled, (state, action) => {
      state.transformedRecord =
        action.payload.transformation.transformed_record;
      state.rejectionReasons = action.payload.transformation.rejection_reasons;
      state.deletionReasons = action.payload.transformation.deletion_reasons;
    });
  },
});

export const selectAppDetails = (state) => state.entities.appDetails;

const { actions, reducer } = AppDetailsSlice;

export default reducer;
