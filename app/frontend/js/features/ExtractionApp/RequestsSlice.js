import {
  createAsyncThunk,
  createSlice,
  createEntityAdapter,
} from "@reduxjs/toolkit";
import { request } from "~/js/utils/request";

const requestsAdapter = createEntityAdapter();

export const previewRequest = createAsyncThunk(
  "requests/previewRequestSlice",

  async (payload) => {
    const { id, pipelineId, harvestDefinitionId, extractionDefinitionId, previousRequestId } = payload;

    let path = `/pipelines/${pipelineId}/harvest_definitions/${harvestDefinitionId}/extraction_definitions/${extractionDefinitionId}/requests/${id}`

    if(previousRequestId != undefined) {
      path = `${path}?previous_request_id=${previousRequestId}`
    }
   
    const response = request
      .get(path)
      .then((response) => {
        return response.data;
      });

    return response;
  }
);

export const updateRequest = createAsyncThunk(
  "requests/updateRequestSlice",
  
  async (payload) => {
    const { id, pipelineId, harvestDefinitionId, extractionDefinitionId, requestId, http_method } = payload;
   
    const response = request
      .patch(
        `/pipelines/${pipelineId}/harvest_definitions/${harvestDefinitionId}/extraction_definitions/${extractionDefinitionId}/requests/${requestId}`,
        {
          request: {
            http_method: http_method
          },
        }
      )
      .then((response) => {
        return response.data;
      });

    return response;
  }
)

const requestsSlice = createSlice({
  name: "requestsSlice",
  initialState: {},
  reducers: {},
  extraReducers: (builder) => {
    builder
      .addCase(updateRequest.fulfilled, (state, action) => {
        requestsAdapter.setOne(state, action.payload);
    })
      .addCase(previewRequest.fulfilled, (state, action) => {
        requestsAdapter.setOne(state, action.payload);
    })
  }
});

const { actions, reducer } = requestsSlice;

export const {
  selectById: selectRequestById,
  selectIds: selectRequestIds,
  selectAll: selectAllRequests,
} = requestsAdapter.getSelectors((state) => state.entities.requests);

export const {} = actions;

export default reducer;
