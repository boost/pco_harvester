
import { bindTestForm } from "./utils/test-form";
import { EditorState } from "@codemirror/state";
import { EditorView, basicSetup } from "codemirror";
import { json } from "@codemirror/lang-json";

bindTestForm('test_enrichment_extraction', 'js-test-enrichment-extraction-button', 'js-extraction-definition-form', (response, _alertClass) => {
  let editor = new EditorView({
    state: EditorState.create({
      extensions: [basicSetup, json(), EditorState.readOnly.of(true)],
      doc: JSON.stringify(JSON.parse(response.data.body), null, 2),
    }),
    parent: document.body,
  });

  document.querySelector("#js-enrichment-extraction-result").innerHTML = "";
  document
    .querySelector("#js-enrichment-extraction-result")
    .append(editor.dom);
}, () => {
  document.querySelector("#js-enrichment-extraction-result").innerHTML = "";
  document.getElementById(
    "js-enrichment-extraction-result"
  ).innerHTML = `<div class="alert alert-danger my-2" role="alert">
    Something went wrong fetching your enrichment from the Enrichment URL. Please confirm that your Enrichment URL is correct.
  </div>`;
});
