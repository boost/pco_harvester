import React, { useRef, useEffect } from "react";
import { EditorView, basicSetup } from "codemirror";
import { StreamLanguage } from "@codemirror/language";
import { EditorState } from "@codemirror/state";
import { ruby } from "@codemirror/legacy-modes/mode/ruby";

const CodeEditor = ({ initContent, onChange, ...props }) => {
  const editorRef = useRef();

  useEffect(() => {
    const state = EditorState.create({
      doc: initContent,
      extensions: [
        basicSetup,
        StreamLanguage.define(ruby),
        EditorView.updateListener.of(function (e) {
          onChange({ target: { value: e.state.doc.toString() } });
        }),
      ],
    });

    const view = new EditorView({ state, parent: editorRef.current });

    return () => view.destroy();
  }, []);

  return <div ref={editorRef} {...props}></div>;
};

export default CodeEditor;
