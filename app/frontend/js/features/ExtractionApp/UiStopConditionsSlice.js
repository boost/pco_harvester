import { createSlice, createEntityAdapter } from "@reduxjs/toolkit";

import { addStopCondition } from "./StopConditionsSlice";

const uiStopConditionsAdapter = createEntityAdapter();

const uiStopConditionsSlice = createSlice({
  name: "stopConditionsSlice",
  initialState: {},
  reducers: {},
  extraReducers: (builder) => {
    // builder
    //   .addCase(addParameter.fulfilled, (state, action) => {
    //     uiParametersAdapter.updateMany(
    //       state,
    //       state.ids.map((id) => {
    //         return { id: id, changes: { active: false } };
    //       })
    //     );

    //     uiParametersAdapter.upsertOne(state, {
    //       id: action.payload.id,
    //       saved: true,
    //       deleting: false,
    //       saving: false,
    //       expanded: true,
    //       displayed: true,
    //       active: true,
    //     });
    //   })
  },
});

const { actions, reducer } = uiStopConditionsSlice;

export const {
  selectById: selectUiStopConditionById,
  selectIds: selectUiStopConditionIds,
  selectAll: selectAllUiStopConditions,
} = uiStopConditionsAdapter.getSelectors((state) => state.ui.stopConditions);

// export const selectDisplayedParameterIds = (state) => {
//   return selectAllUiParameters(state)
//     .filter((parameter) => parameter.displayed)
//     .map((parameter) => parameter.id);
// };

export const {} = actions;

export default reducer;
