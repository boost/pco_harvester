import React, { useRef, useEffect } from 'react';
import {EditorState} from "@codemirror/state"
import {EditorView, basicSetup} from "codemirror"
import {json} from "@codemirror/lang-json"

const RecordViewer = ({record}) => {
  const editor = useRef();

  useEffect(() => {
    const state = EditorState.create({
      doc: JSON.stringify(record, null, 2),
      extensions: [
        basicSetup,
        json(),
        EditorState.readOnly.of(true)
      ],
    })

    const view = new EditorView({ state, parent: editor.current })

    return () => {
      view.destroy()
    }
  }, [])
  
  return (
    <div className="record-view record-view--transformation">
      <div className='record-view__container' ref={editor}></div>
    </div>
  )
}

export default RecordViewer;
