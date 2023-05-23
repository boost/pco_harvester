import { bindTestForm } from './utils/test-form';
import { EditorState } from "@codemirror/state";
import { EditorView, basicSetup } from "codemirror";
import { json } from "@codemirror/lang-json";

bindTestForm('test_record_extraction', 'js-test-record-extraction', (response, _alertClass) => {
  let editor = new EditorView({
    state: EditorState.create({
      extensions: [basicSetup, json(), EditorState.readOnly.of(true)],
      doc: JSON.stringify(JSON.parse(response.data.body), null, 2),
    }),
    parent: document.body,
  });

  document.querySelector("#js-record-extraction-result").innerHTML = "";
  document
    .querySelector("#js-record-extraction-result")
    .append(editor.dom);
}, () => {
  document.querySelector("#js-record-extraction-result").innerHTML = "";
  document.getElementById(
    "js-record-extraction-result"
  ).innerHTML = `<div class="alert alert-danger my-2" role="alert">
    Something went wrong fetching your records from the API Source. Please confirm that your API Source details and Source ID are correct.
  </div>`;
});
