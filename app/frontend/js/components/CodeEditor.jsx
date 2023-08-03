import React, { useRef, useEffect } from "react";
import { EditorView, basicSetup } from "codemirror";
import { StreamLanguage } from "@codemirror/language";
import { EditorState } from "@codemirror/state";
import { json } from "@codemirror/lang-json";
import { ruby } from "@codemirror/legacy-modes/mode/ruby";

const CodeEditor = ({ initContent, onChange, format = 'ruby', ...props }) => {
  const editorRef = useRef();

  const editorExtensions = () => {
    if(format == 'JSON') {
      return [ 
        basicSetup, 
        json(), 
        EditorState.readOnly.of(true) 
      ];
    } else if(format == 'ruby') {
      return [ 
        basicSetup, 
        StreamLanguage.define(ruby), 
        EditorView.updateListener.of(function (e) {
          onChange({ target: { value: e.state.doc.toString() } });
        })
      ]
    }
  }

  const doc = () => {
    if(format == 'JSON') {
      return JSON.stringify(JSON.parse(initContent), null, 2 )
    } else if(format == 'ruby') {
      return initContent;
    }
  }

  useEffect(() => {
    const state = EditorState.create({
      doc: doc(),
      extensions: editorExtensions(),
    });

    const view = new EditorView({ state, parent: editorRef.current });

    return () => view.destroy();
  }, []);

  return <div ref={editorRef} {...props}></div>;
};

export default CodeEditor;
