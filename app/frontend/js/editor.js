import {EditorState} from "@codemirror/state"
import {EditorView, basicSetup} from "codemirror"
import {json} from "@codemirror/lang-json"

const erv = document.querySelector("#extraction-result-viewer");
let editor = new EditorView({
  state: EditorState.create({
    extensions: [basicSetup, json(), EditorState.readOnly.of(true)],
    doc: JSON.stringify(JSON.parse(erv.dataset.results), null, 2),
  }),
  parent: document.body,
});

document.querySelector('#extraction-result-viewer').append(editor.dom)
