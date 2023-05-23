import { request } from "./utils/request";
import { EditorState } from "@codemirror/state";
import { EditorView, basicSetup } from "codemirror";
import { json } from "@codemirror/lang-json";

document.addEventListener(
  "DOMContentLoaded",
  function () {
    function sendData(form) {
      // Bind the FormData object and the form element
      const FD = new FormData(form);
      FD.set("_method", "post");

      const path = `${form.action.replace(/\/\d+$/, "")}/test_record_extraction`;
      // Fetches the response
      
      request.post(path, FD).then(function (response) {
        let record_selector_viewer_editor = new EditorView({
          state: EditorState.create({
            extensions: [basicSetup, json(), EditorState.readOnly.of(true)],
            doc: JSON.stringify(JSON.parse(response.data.body), null, 2),
          }),
          parent: document.body,
        });

        document.querySelector("#js-record-extraction-result").innerHTML = "";
        document
          .querySelector("#js-record-extraction-result")
          .append(record_selector_viewer_editor.dom);
      });
    }

    const button = this.getElementById("js-test-record-extraction");

    if (button) {
      const form = button.closest("form");
      button.addEventListener("click", (event) => {
        sendData(form);
      });
    }
  },
  false
);
