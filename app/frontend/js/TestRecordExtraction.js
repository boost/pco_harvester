import { bindTestForm } from "./utils/test-form";
import { EditorState } from "@codemirror/state";
import { EditorView, basicSetup } from "codemirror";
import { json } from "@codemirror/lang-json";

bindTestForm(
  "test_record_extraction",
  "js-test-record-extraction-button",
  "js-extraction-definition-form",
  (response, _alertClass) => {
    let editor = new EditorView({
      state: EditorState.create({
        extensions: [basicSetup, json(), EditorState.readOnly.of(true)],
        doc: JSON.stringify(JSON.parse(response.data.body), null, 2),
      }),
      parent: document.body,
    });

    document.querySelector("#js-record-extraction-result").innerHTML = "";
    document.querySelector("#js-record-extraction-result").append(editor.dom);
  },
  () => {
    document.querySelector("#js-record-extraction-result").innerHTML = "";
    document.getElementById(
      "js-record-extraction-result"
    ).innerHTML = `<p>
    Something went wrong fetching your records from the Preview Target. Please confirm that your Preview Target and Preview Source ID are correct.
  </p>`;
  }
);
