import axios, {isCancel, AxiosError} from 'axios';
import { createAsyncThunk, createSlice } from "@reduxjs/toolkit";
import { remove } from 'lodash';

export const addField = createAsyncThunk(
  "fields/addFieldStatus",
  async (payload) => {
    const { name, block, contentPartnerId, transformationId } = payload;

    const response = axios.post(
      `/content_partners/${contentPartnerId}/transformations/${transformationId}/fields`, {
        field: {
          content_partner_id: contentPartnerId,
          transformation_id: transformationId,
          name: name,
          block: block
        }
    }).then(function  (response) {
      return response.data;
    })
    
    return response;
  }
);

export const deleteField = createAsyncThunk(
  "fields/deleteFieldStatus",
  async (payload) => {
    const { id, contentPartnerId, transformationId } = payload;

    const response = axios.delete(`/content_partners/${contentPartnerId}/transformations/${transformationId}/fields/${id}`)
      .then(response => {
        return id;
      })

    return response;
  }
);

const fieldsSlice = createSlice({
  name: "fieldsSlice",
  initialState: {},
  reducers: {},
  extraReducers: (builder) => {
    builder
    .addCase(addField.fulfilled, (state, action) => {
      state.push(action.payload);
    })
    .addCase(deleteField.fulfilled, (state, action) => {
      remove(state, (field) => {
        return field.id === action.payload;
      })
    })
  }
});

export const selectFields = (state) => state.entities.fields;

const { actions, reducer } = fieldsSlice;

export const {} = actions;

export default reducer;

