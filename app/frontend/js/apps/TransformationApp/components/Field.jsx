import React, { useRef, useEffect } from 'react';
import {EditorState} from "@codemirror/state"
import {EditorView, basicSetup} from "codemirror"
import {StreamLanguage} from "@codemirror/language"
import {ruby} from "@codemirror/legacy-modes/mode/ruby"

const Field = ({ id, name, block }) => {
  const editor = useRef();

  useEffect(() => {
    const state = EditorState.create({
      doc: block,
      extensions: [
        basicSetup,
        StreamLanguage.define(ruby),
      ],
    })

    const view = new EditorView({ state, parent: editor.current })

    return () => {
      view.destroy()
    }
  }, [])
  
  return (
    <div className="accordion accordion-flush mb-2">
      <div className="accordion-item">
        <h2 className="accordion-header">
          <button className="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target={`#field-${id}`} aria-expanded="false" aria-controls={`#field-${id}`}>
            { name }
          </button>
        </h2>
        <div id={`field-${id}`} className="accordion-collapse collapse">
          <div className="accordion-body">

            <label className="form-label">Field Name</label>
            <p className='form-text'>This is the field name that the result of this transformation will appear under on the transformed record.</p>
            <input type="text" className="form-control" required="required" placeholder='New field' />
 
            <label className="form-label mt-4">Field Code</label>
            <p className='form-text'>This is the code that is applied to create this field on the transformed record.</p>

            <div ref={editor}></div>

            <div className='mt-4 float-end'>
              <span className="btn btn-danger me-2">Delete</span>
              <span className="btn btn-primary me-2">Save</span>
              <span className="btn btn-success">Run</span>
            </div>

            <div className="clearfix"></div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default Field;
