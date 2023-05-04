import { createAsyncThunk, createSlice } from "@reduxjs/toolkit";

export const addField = createAsyncThunk(
  "fields/addFieldStatus",
  async (payload) => {
    const { name, block, contentPartnerId, transformationId } = payload;

    let postPayload = {
      name: name,
      block: block,
      transformation_id: transformationId,
      content_partner_id: contentPartnerId
    };

    // const response = await request({
    //   url: `/content_partners/${contentPartnerId}/transformations/${transformationId}/fields`,
    //   body: { postPayload },
    //   options: { method: "POST" },
    // })
    //   .then((req) => req.json())
    //   .then((json) => {
    //     return json;
    //   });

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

    })
  }
});

export const selectFields = (state) => state.entities.fields;

const { actions, reducer } = fieldsSlice;

export const {} = actions;

export default reducer;

