import React, { useRef, useEffect, useState } from "react";
import { useSelector, useDispatch } from "react-redux";
import classnames from "classnames";

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
  const { saved, deleting, saving, running, error, hasRun, successfulRun } =
    useSelector((state) => selectUiFieldById(state, id));

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
    return isValid() && hasChanged() && !saving;
  };

  const badgeClasses = classnames({
    badge: true,
    "ms-2": true,
    "bg-primary": saved,
    "bg-success": hasRun && !error,
    "bg-secondary": hasChanged(),
    "bg-danger": hasRun && error,
  });

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

  const badgeText = () => {
    if (hasRun && !error) {
      return "success";
    } else if (hasChanged()) {
      return "unsaved";
    } else if (hasRun && error) {
      return "error";
    } else if (saved) {
      return "saved";
    }
  };

  return (
    <div className="card mb-4" data-bs-spy="scroll" data-bs-target="#simple-list-example" data-bs-offset="0" data-bs-smooth-scroll="true" id={`field-${id}`}>
      <div className="card-body">
        <h5 className="card-title mb-4">
          { name }
          {name != "" && <span className={badgeClasses}>{badgeText()}</span> }
        </h5>

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

        {error && (
          <div className="alert alert-danger mt-4" role="alert">
            <h4 className="alert-heading">{error.title}</h4>
            <hr />
            <p className="mb-0">{error.description}</p>
          </div>
        )}

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
            disabled={!saved || hasChanged() || running}
            onClick={handleRunClick}
          >
            {running ? "Running..." : "Run"}
          </button>
        </div>
      </div>
    </div>
  );
};

export default Field;
