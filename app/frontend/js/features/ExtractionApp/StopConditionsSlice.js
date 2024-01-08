import {
  createAsyncThunk,
  createSlice,
  createEntityAdapter,
} from "@reduxjs/toolkit";
import { request } from "~/js/utils/request";

import { some } from "lodash";

const stopConditionsAdapter = createEntityAdapter({
  sortComparer: (stopConditionOne, stopConditionTwo) =>
    stopConditionTwo.created_at.localeCompare(stopConditionOne.created_at),
});

export const addStopCondition = createAsyncThunk(
  "stopConditions/addStopConditionStatus",
  async (payload) => {
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
          stop_condition: {
            name: name,
            content: content,
            extraction_definition_id: extractionDefinitionId,
          },
        }
      )
      .then(function (response) {
        return response.data;
      });

    return response;
  }
);

export const updateStopCondition = createAsyncThunk(
  "fields/updateStopConditionStatus",
  async (payload) => {
    const {
      id,
      pipelineId,
      harvestDefinitionId,
      extractionDefinitionId,
      name,
      content,
    } = payload;

    const response = request
      .patch(
        `/pipelines/${pipelineId}/harvest_definitions/${harvestDefinitionId}/extraction_definitions/${extractionDefinitionId}/stop_conditions/${id}`,
        {
          stop_condition: {
            name: name,
            content: content,
          },
        }
      )
      .then((response) => {
        return response.data;
      });

    return response;
  }
);

export const deleteStopCondition = createAsyncThunk(
  "fields/deleteStopConditionStatus",
  async (payload) => {
    const { id, pipelineId, harvestDefinitionId, extractionDefinitionId } =
      payload;

    const response = request
      .delete(
        `/pipelines/${pipelineId}/harvest_definitions/${harvestDefinitionId}/extraction_definitions/${extractionDefinitionId}/stop_conditions/${id}`
      )
      .then((response) => {
        return id;
      });

    return response;
  }
);

const stopConditionsSlice = createSlice({
  name: "stopConditionsSlice",
  initialState: {},
  reducers: {},
  extraReducers: (builder) => {
    builder
      .addCase(addStopCondition.fulfilled, (state, action) => {
        stopConditionsAdapter.upsertOne(state, action.payload);
      })
      .addCase(deleteStopCondition.fulfilled, (state, action) => {
        stopConditionsAdapter.removeOne(state, action.payload);
      })
      .addCase(updateStopCondition.fulfilled, (state, action) => {
        stopConditionsAdapter.setOne(state, action.payload);
      });
  },
});

const { actions, reducer } = stopConditionsSlice;

export const hasEmptyStopConditions = (state) => {
  return some(selectAllStopConditions(state), { content: "" });
};

export const {
  selectById: selectStopConditionById,
  selectIds: selectStopConditionIds,
  selectAll: selectAllStopConditions,
} = stopConditionsAdapter.getSelectors(
  (state) => state.entities.stopConditions
);

export const {} = actions;

export default reducer;
