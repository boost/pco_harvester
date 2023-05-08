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

      const path = `${form.action.replace(/\/\d+$/, "")}/test`;
      // Fetches the response
      fetch(path, {
        method: "POST",
        body: FD,
      })
        .then(function (response) {
          return response.ok ? response.json() : Promise.reject();
        })
        .then(function (data) {
          let record_selector_viewer_editor = new EditorView({
            state: EditorState.create({
              extensions: [basicSetup, json(), EditorState.readOnly.of(true)],
              doc: JSON.stringify(data, null, 2),
            }),
            parent: document.body,
          });

          document.querySelector("#js-record-selector-result").innerHTML = "";
          document
            .querySelector("#js-record-selector-result")
            .append(record_selector_viewer_editor.dom);
        });
    }

    const button = this.getElementById("js-test-transformation");

    if (button) {
      const form = button.closest("form");
      button.addEventListener("click", (event) => {
        sendData(form);
      });
    }
  },
  false
);
