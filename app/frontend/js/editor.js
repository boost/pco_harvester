import { EditorState } from "@codemirror/state";
import { EditorView, basicSetup } from "codemirror";
import { json } from "@codemirror/lang-json";
import { xml } from "@codemirror/lang-xml";
import xmlFormat from 'xml-formatter';

import { StreamLanguage } from "@codemirror/language";
import { ruby } from "@codemirror/legacy-modes/mode/ruby";

// Job Extraction Result Viewer

const extraction_result_viewer = document.querySelector(
  "#extraction-result-viewer"
);

if (extraction_result_viewer) {

  if(extraction_result_viewer.dataset.format == 'JSON') {
    let extraction_result_viewer_editor = new EditorView({
      state: EditorState.create({
        extensions: [basicSetup, json(), EditorState.readOnly.of(true)],
        doc: JSON.stringify(
          JSON.parse(extraction_result_viewer.dataset.results),
          null,
          2
        ),
      }),
      parent: document.body,
    });

    document
      .querySelector("#extraction-result-viewer")
      .append(extraction_result_viewer_editor.dom);

  } else if(extraction_result_viewer.dataset.format == 'XML') {
    // TODO why doesnt the syntax highlight work?
    // const parser = new DOMParser();
    // const parsedXML = parser.parseFromString(extraction_result_viewer.dataset.results, 'text/xml');
    // new XMLSerializer().serializeToString(parsedXML);
    
    let extraction_result_viewer_editor = new EditorView({
      state: EditorState.create({
        extensions: [basicSetup, xml(), EditorState.readOnly.of(true)],
        doc: xmlFormat(extraction_result_viewer.dataset.results)
      }),
      parent: document.body,
    });

    document
      .querySelector("#extraction-result-viewer")
      .append(extraction_result_viewer_editor.dom);
  }

}

// Enrichment URL Editor
const enrichment_field = document.querySelector(
  "#js-enrichment-url"
);

function updateEnrichmentUrl(value) {
  enrichment_field.value = value;
}

if (enrichment_field) {
  let enrichment_field_editor = new EditorView({
    state: EditorState.create({
      extensions: [
        basicSetup, 
        StreamLanguage.define(ruby),
        EditorView.updateListener.of(function (e) {
          updateEnrichmentUrl(e.state.doc.toString());
        })
      ],
      doc: enrichment_field.value,
    }),
    parent: document.body,
  });

  document
    .querySelector("#js-enrichment-editor")
    .append(enrichment_field_editor.dom);
}

