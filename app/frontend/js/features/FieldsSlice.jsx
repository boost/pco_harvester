import axios, {isCancel, AxiosError} from 'axios';
import { createAsyncThunk, createSlice, createEntityAdapter } from "@reduxjs/toolkit";
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

export const updateField = createAsyncThunk(
  "fields/updateFieldStatus",
  async (payload) => {

    const { id, contentPartnerId, transformationId, name, block } = payload; 

    const response = axios.patch(`/content_partners/${contentPartnerId}/transformations/${transformationId}/fields/${id}`, {
      field: {
        name: name,
        block: block
      }
    })
      .then(response => {
      return response.data;
    });

    return response;
  }
);

const fieldsAdapter = createEntityAdapter();

const fieldsSlice = createSlice({
  name: "fieldsSlice",
  initialState: {},
  reducers: {},
  extraReducers: (builder) => {
    builder
    .addCase(addField.fulfilled, (state, action) => {
      fieldsAdapter.upsertOne(state, action.payload);
    })
    .addCase(deleteField.fulfilled, (state, action) => {
      fieldsAdapter.removeOne(state, action.payload);
    })
    .addCase(updateField.fulfilled, (state, action) => {
      fieldsAdapter.setOne(state, action.payload);
    })
  }
});

const { actions, reducer } = fieldsSlice;

export const {
  selectAll: selectAllFields,
} = fieldsAdapter.getSelectors((state) => state.entities.fields);

export const {} = actions;

export default reducer;

