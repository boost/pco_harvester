import React, { useRef, useEffect, useState } from "react";
import { useSelector, useDispatch } from "react-redux";

import { updateField, deleteField } from "~/js/features/FieldsSlice";
import { selectFieldById } from "~/js/features/FieldsSlice";
import {
  selectAppDetails,
  clickedOnRunFields,
} from "~/js/features/AppDetailsSlice";

import { EditorState } from "@codemirror/state";
import { EditorView, basicSetup } from "codemirror";
import { StreamLanguage } from "@codemirror/language";
import { ruby } from "@codemirror/legacy-modes/mode/ruby";
import { selectUiFieldById } from "~/js/features/UiFieldsSlice";

const Field = ({ id }) => {
  const appDetails = useSelector(selectAppDetails);
  const { name, block } = useSelector((state) => selectFieldById(state, id));
  const { saved, deleting, saving, running } = useSelector((state) =>
    selectUiFieldById(state, id)
  );

  const dispatch = useDispatch();
  const editorRef = useRef();

  const [nameValue, setNameValue] = useState(name);
  const [blockValue, setBlockValue] = useState(block);

  const handleSaveClick = () => {
    dispatch(
      updateField({
        id: id,
        name: nameValue,
        block: blockValue,
      })
    );
  };

  const handleDeleteClick = () => {
    dispatch(
      deleteField({
        id: id,
        contentPartnerId: appDetails.contentPartner.id,
        transformationDefinitionId: appDetails.transformationDefinition.id,
      })
    );
  };

  const handleRunClick = () => {
    dispatch(
      clickedOnRunFields({
        contentPartnerId: appDetails.contentPartner.id,
        transformationDefinitionId: appDetails.transformationDefinition.id,
        record: appDetails.rawRecord,
        fields: [id],
      })
    );
  };

  const isValid = () => {
    return nameValue.trim() !== "" && blockValue.trim() !== "";
  };

  const hasChanged = () => {
    return name !== nameValue.trim() || block !== blockValue.trim();
  };

  const isSaveable = () => {
    return isValid() && hasChanged();
  };

  useEffect(() => {
    const state = EditorState.create({
      doc: block,
      extensions: [
        basicSetup,
        StreamLanguage.define(ruby),
        EditorView.updateListener.of(function (e) {
          setBlockValue(e.state.doc.toString());
        }),
      ],
    });

    const view = new EditorView({ state, parent: editorRef.current });

    return () => view.destroy();
  }, []);

  return (
    <div className="accordion accordion-flush mb-2">
      <div className="accordion-item">
        <h2 className="accordion-header">
          <button
            className="accordion-button collapsed"
            type="button"
            data-bs-toggle="collapse"
            data-bs-target={`#field-${id}`}
            aria-expanded="false"
            aria-controls={`#field-${id}`}
          >
            {name}
          </button>
        </h2>
        <div id={`field-${id}`} className="accordion-collapse collapse">
          <div className="accordion-body">
            <label className="form-label">Field Name</label>
            <p className="form-text">
              This is the field name that the result of this transformation will
              appear under on the transformed record.
            </p>
            <input
              type="text"
              className="form-control"
              required="required"
              placeholder="New field"
              defaultValue={name}
              onChange={(e) => setNameValue(e.target.value)}
            />

            <label className="form-label mt-4">Field Block</label>
            <p className="form-text">
              This is the code that is applied to create this field on the
              transformed record.
            </p>

            <div ref={editorRef}></div>

            <div className="mt-4 hstack gap-2">
              <div className="ms-auto"></div>
              <button className="btn btn-danger" onClick={handleDeleteClick}>
                {deleting ? "Deleting..." : "Delete"}
              </button>
              <button
                className="btn btn-primary"
                disabled={!isSaveable()}
                onClick={handleSaveClick}
              >
                {saving ? "Saving..." : "Save"}
              </button>
              <button
                className="btn btn-success"
                disabled={!saved || hasChanged()}
                onClick={handleRunClick}
              >
                {running ? "Running..." : "Run"}
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Field;
