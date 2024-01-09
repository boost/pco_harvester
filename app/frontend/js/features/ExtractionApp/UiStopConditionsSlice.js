import { createSlice, createEntityAdapter } from "@reduxjs/toolkit";

import { addStopCondition } from "./StopConditionsSlice";

const uiStopConditionsAdapter = createEntityAdapter();

const uiStopConditionsSlice = createSlice({
  name: "stopConditionsSlice",
  initialState: {},
  reducers: {
    toggleDisplayStopCondition(state, action) {
      uiStopConditionsAdapter.updateOne(state, {
        id: action.payload.id,
        changes: { displayed: action.payload.displayed },
      });
    },
    setActiveStopCondition(state, action) {
      uiStopConditionsAdapter.updateMany(
        state,
        state.ids.map((id) => {
          return { id: id, changes: { active: false } };
        })
      );

      uiStopConditionsAdapter.updateOne(state, {
        id: action.payload,
        changes: { active: true },
      });
    },
    toggleDisplayStopConditions(state, action) {
      const { stopConditions, displayed } = action.payload;

      uiStopConditionsAdapter.updateMany(
        state,
        stopConditions.map((stopCondition) => {
          return { id: stopCondition.id, changes: { displayed: displayed } };
        })
      );
    },
  },
  extraReducers: (builder) => {
    builder.addCase(addStopCondition.fulfilled, (state, action) => {
      uiStopConditionsAdapter.updateMany(
        state,
        state.ids.map((id) => {
          return { id: id, changes: { active: false } };
        })
      );

      uiStopConditionsAdapter.upsertOne(state, {
        id: action.payload.id,
        saved: true,
        deleting: false,
        saving: false,
        expanded: true,
        displayed: true,
        active: true,
      });
    });
  },
});

const { actions, reducer } = uiStopConditionsSlice;

export const {
  selectById: selectUiStopConditionById,
  selectIds: selectUiStopConditionIds,
  selectAll: selectAllUiStopConditions,
} = uiStopConditionsAdapter.getSelectors((state) => state.ui.stopConditions);

export const {
  toggleDisplayStopCondition,
  toggleDisplayStopConditions,
  setActiveStopCondition,
} = actions;

export default reducer;
