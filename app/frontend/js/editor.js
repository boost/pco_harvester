import {EditorState} from "@codemirror/state"
import {EditorView, basicSetup} from "codemirror"
import {json} from "@codemirror/lang-json"

import {StreamLanguage} from "@codemirror/language"
import {ruby} from "@codemirror/legacy-modes/mode/ruby"

// Job Extraction Result Viewer

const extraction_result_viewer = document.querySelector("#extraction-result-viewer");

if (extraction_result_viewer) {
    let extraction_result_viewer_editor = new EditorView({
    state: EditorState.create({
      extensions: [basicSetup, json(), EditorState.readOnly.of(true)],
      doc: JSON.stringify(JSON.parse(extraction_result_viewer.dataset.results), null, 2),
    }),
    parent: document.body,
  });

  document.querySelector('#extraction-result-viewer').append(extraction_result_viewer_editor.dom)
}
