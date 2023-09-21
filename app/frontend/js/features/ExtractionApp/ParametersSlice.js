import {
  createAsyncThunk,
  createSlice,
  createEntityAdapter,
} from "@reduxjs/toolkit";
import { request } from "~/js/utils/request";

import { some } from "lodash";

const parametersAdapter = createEntityAdapter({
  sortComparer: (parameterOne, parameterTwo) =>
    parameterTwo.created_at.localeCompare(parameterOne.created_at),
});

export const addParameter = createAsyncThunk(
  "parameters/addParameterStatus",
  async (payload) => {
    const {
      name,
      content,
      kind,
      content_type,
      harvestDefinitionId,
      pipelineId,
      extractionDefinitionId,
      requestId,
    } = payload;

    const response = request
      .post(
        `/pipelines/${pipelineId}/harvest_definitions/${harvestDefinitionId}/extraction_definitions/${extractionDefinitionId}/requests/${requestId}/parameters`,
        {
          parameter: {
            request_id: requestId,
            kind: kind,
            name: name,
            content: content,
            content_type: content_type,
          },
        }
      )
      .then(function (response) {
        return response.data;
      });

    return response;
  }
);

export const updateParameter = createAsyncThunk(
  "parameters/updateParameterSlice",

  async (payload) => {
    const {
      id,
      pipelineId,
      harvestDefinitionId,
      extractionDefinitionId,
      requestId,
      name,
      content,
      kind,
      content_type,
    } = payload;

    const response = request
      .patch(
        `/pipelines/${pipelineId}/harvest_definitions/${harvestDefinitionId}/extraction_definitions/${extractionDefinitionId}/requests/${requestId}/parameters/${id}`,
        {
          parameter: {
            name: name,
            content: content,
            kind: kind,
            content_type: content_type,
          },
        }
      )
      .then((response) => {
        return response.data;
      });

    return response;
  }
);

export const deleteParameter = createAsyncThunk(
  "parameters/deleteParameterStatus",
  async (payload) => {
    const {
      id,
      pipelineId,
      harvestDefinitionId,
      extractionDefinitionId,
      requestId,
    } = payload;

    const response = request
      .delete(
        `/pipelines/${pipelineId}/harvest_definitions/${harvestDefinitionId}/extraction_definitions/${extractionDefinitionId}/requests/${requestId}/parameters/${id}`
      )
      .then((response) => {
        return id;
      });

    return response;
  }
);

const parametersSlice = createSlice({
  name: "parametersSlice",
  initialState: {},
  reducers: {},
  extraReducers: (builder) => {
    builder
      .addCase(addParameter.fulfilled, (state, action) => {
        parametersAdapter.upsertOne(state, action.payload);
      })
      .addCase(deleteParameter.fulfilled, (state, action) => {
        parametersAdapter.removeOne(state, action.payload);
      })
      .addCase(updateParameter.fulfilled, (state, action) => {
        parametersAdapter.setOne(state, action.payload);
      });
  },
});

const { actions, reducer } = parametersSlice;

export const {
  selectById: selectParameterById,
  selectIds: selectParameterIds,
  selectAll: selectAllParameters,
} = parametersAdapter.getSelectors((state) => state.entities.parameters);

export const hasEmptyParameters = (state) => {
  return some(selectAllParameters(state), { content: "" });
};

export const selectParameterIdsByRequestAndKind = (state, requestId, type) => {
  return selectAllParameters(state)
    .filter((parameter) => parameter.request_id === requestId)
    .filter((parameter) => parameter.kind === type)
    .map((parameter) => parameter.id);
};

export const {} = actions;

export default reducer;
