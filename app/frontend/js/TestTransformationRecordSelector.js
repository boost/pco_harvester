import { bindTestForm } from './utils/test-form';
import { EditorState } from "@codemirror/state";
import { EditorView, basicSetup } from "codemirror";
import { json } from "@codemirror/lang-json";

bindTestForm('test', 'js-test-transformation-record-selector-button', 'js-transformation-definition-form', (response, _alertClass) => {
    let editor = new EditorView({
      state: EditorState.create({
        extensions: [basicSetup, json(), EditorState.readOnly.of(true)],
        doc: JSON.stringify(response.data, null, 2),
      }),
      parent: document.body,
    });

    document.querySelector("#js-record-selector-result").innerHTML = "";
    document
      .querySelector("#js-record-selector-result")
      .append(editor.dom);
});
