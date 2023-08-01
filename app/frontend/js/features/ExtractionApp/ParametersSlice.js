import {
  createAsyncThunk,
  createSlice,
  createEntityAdapter,
} from "@reduxjs/toolkit";
import { request } from "~/js/utils/request";

const parametersAdapter = createEntityAdapter();

export const addParameter = createAsyncThunk(
  "fields/addParameterStatus",
  async (payload) => {
    const { name, content, kind, harvestDefinitionId, pipelineId, extractionDefinitionId, requestId } = payload;

    const response = request
      .post(
        `/pipelines/${pipelineId}/harvest_definitions/${harvestDefinitionId}/extraction_definitions/${extractionDefinitionId}/requests/${requestId}/parameters`,
        {
          parameter: {
            request_id: requestId,
            kind: kind,
            name: name,
            content: content
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
  "fields/updateParameterSlice",
  
  async (payload) => {
    const { id, pipelineId, harvestDefinitionId, extractionDefinitionId, requestId, name, content, kind } = payload;
   
    const response = request
      .patch(
        `/pipelines/${pipelineId}/harvest_definitions/${harvestDefinitionId}/extraction_definitions/${extractionDefinitionId}/requests/${requestId}/parameters/${id}`,
        {
          parameter: {
            name: name,
            content: content,
            kind: kind
          },
        }
      )
      .then((response) => {
        return response.data;
      });

    return response;
  }
)

const parametersSlice = createSlice({
  name: "parametersSlice",
  initialState: {},
  reducers: {},
  extraReducers: (builder) => {
    builder
      .addCase(addParameter.fulfilled, (state, action) => {
        parametersAdapter.upsertOne(state, action.payload);
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

export const {} = actions;

export default reducer;
