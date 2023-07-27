import { createAsyncThunk, createSlice } from "@reduxjs/toolkit";
import { request } from "../utils/request";

export const askNewRawRecord = createAsyncThunk(
  "fields/askNewRawRecordStatus",
  async (payload) => {
    const { transformationDefinitionId, page, record, fields } = payload;

    const response = request
      .get(
        `/transformation_definitions/${transformationDefinitionId}/raw_records`,
        { params: { page: page, record: record, fields: fields } }
      )
      .then(function (response) {
        return response.data;
      });

    return response;
  }
);

const rawRecordSlice = createSlice({
  name: "rawRecordSlice",
  initialState: {},
  reducers: {},
  extraReducers: (builder) => {
    builder
      .addCase(askNewRawRecord.pending, (state) => {
        state.isFetching = true;
        state.error = null;
      })
      .addCase(askNewRawRecord.fulfilled, (state, action) => {
        state.isFetching = false;
        state.error = null;
        state.page = action.payload.rawRecordSlice.page;
        state.record = action.payload.rawRecordSlice.record;
        state.body = action.payload.rawRecordSlice.body;

        window.history.replaceState(
          null,
          null,
          `${window.location.pathname}?page=${state.page}&record=${state.record}`
        );
      })
      .addCase(askNewRawRecord.rejected, (state, action) => {
        state.isFetching = false;
        state.error = "An error occured fetching the raw record.";
      });
  },
});

const { actions, reducer } = rawRecordSlice;

export const selectRawRecord = (state) => state.entities.rawRecord;

export const {} = actions;

export default reducer;
