import React, { useRef, useEffect } from "react";
import { EditorState } from "@codemirror/state";
import { EditorView, basicSetup } from "codemirror";

import { useSelector, useDispatch } from "react-redux";

import { updateField, deleteField } from "/js/features/FieldsSlice";

import {
  selectAppDetails,
  updateTransformedRecord,
} from "/js/features/AppDetailsSlice";

import { StreamLanguage } from "@codemirror/language";
import { ruby } from "@codemirror/legacy-modes/mode/ruby";
import { selectFieldById } from "/js/features/FieldsSlice";

const Field = ({ id }) => {
  const appDetails = useSelector(selectAppDetails);
  const { name, block } = useSelector((state) => selectFieldById(state, id));

  const dispatch = useDispatch();
  const editor = useRef();

  const nameRef = useRef();
  const blockRef = useRef();

  const handleSaveClick = async () => {
    dispatch(
      updateField({
        id: id,
        name: nameRef.current.value,
        block: blockRef.current,
      })
    );
  };

  const handleDeleteClick = async () => {
    await dispatch(
      deleteField({
        id: id,
        contentPartnerId: appDetails.contentPartner.id,
        transformationDefinitionId: appDetails.transformationDefinition.id,
      })
    );
  };

  const handleRunClick = async (fieldId) => {
    await dispatch(
      updateTransformedRecord({
        contentPartnerId: appDetails.contentPartner.id,
        transformationDefinitionId: appDetails.transformationDefinition.id,
        record: appDetails.rawRecord,
        fields: [fieldId],
      })
    );
  };

  useEffect(() => {
    const state = EditorState.create({
      doc: block,
      extensions: [
        basicSetup,
        StreamLanguage.define(ruby),
        EditorView.updateListener.of(function (e) {
          blockRef.current = e.state.doc.toString();
        }),
      ],
    });

    const view = new EditorView({ state, parent: editor.current });

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
              ref={nameRef}
            />

            <label className="form-label mt-4">Field Block</label>
            <p className="form-text">
              This is the code that is applied to create this field on the
              transformed record.
            </p>

            <div ref={editor}></div>

            <div className="mt-4 float-end">
              <button
                className="btn btn-danger me-2"
                onClick={() => {
                  handleDeleteClick();
                }}
              >
                Delete
              </button>
              <button
                className="btn btn-primary me-2"
                onClick={() => {
                  handleSaveClick();
                }}
              >
                Save
              </button>
              <button
                className="btn btn-success"
                onClick={() => {
                  handleRunClick(id);
                }}
              >
                Run
              </button>
            </div>

            <div className="clearfix"></div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Field;
