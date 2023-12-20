import {
  createAsyncThunk,
  createSlice,
  createEntityAdapter,
} from "@reduxjs/toolkit";
import { request } from "~/js/utils/request";

import { some } from 'lodash';

const stopConditionsAdapter = createEntityAdapter({
  sortComparer: (stopConditionOne, stopConditionTwo) =>
    stopConditionTwo.created_at.localeCompare(stopConditionOne.created_at),
});

export const addStopCondition = createAsyncThunk(
  "stopConditions/addStopConditionStatus",
  async(payload) => {
    const {
      name,
      content, 
      harvestDefinitionId,
      pipelineId,
      extractionDefinitionId,
    } = payload;

    const response = request
      .post(
        `/pipelines/${pipelineId}/harvest_definitions/${harvestDefinitionId}/extraction_definitions/${extractionDefinitionId}/stop_conditions`,
        {
          parameter: {
            request_id: requestId,
            kind: kind,
            name: name,
            content: content,
          },
        }
      )
      .then(function (response) {
        return response.data;
      });

    return response;
  }
)

const stopConditionsSlice = createSlice({
  name: "stopConditionsSlice",
  initialState: {},
  reducers: {},
  extraReducers: (builder) => {
    builder
      .addCase(addStopCondition.fulfilled, (state, action) => {
        stopConditionsAdapter.upsertOne(state, action.payload);
      })
  },
});

const { actions, reducer } = stopConditionsSlice;

export const hasEmptyStopConditions = (state) => {
  return some(selectAllStopConditions(state), { content: '' });
}

export const {
  selectById: selectStopConditionById,
  selectIds: selectStopConditionIds,
  selectAll: selectAllStopConditions,
} = stopConditionsAdapter.getSelectors((state) => state.entities.stopConditions);

export const {} = actions;

export default reducer;
