import { EditorState } from "@codemirror/state";
import { EditorView, basicSetup } from "codemirror";
import { json } from "@codemirror/lang-json";
import { xml } from "@codemirror/lang-xml";
import xmlFormat from 'xml-formatter';

import { StreamLanguage } from "@codemirror/language";
import { ruby } from "@codemirror/legacy-modes/mode/ruby";

// Job Extraction Result Viewer

const extractionResultViewer = document.querySelector(
  "#extraction-result-viewer"
);

if (extractionResultViewer) {
  if(extractionResultViewer.dataset.format == 'JSON') {
    let extractionResultViewerEditor = new EditorView({
      state: EditorState.create({
        extensions: [basicSetup, json(), EditorState.readOnly.of(true)],
        doc: JSON.stringify(
          JSON.parse(extractionResultViewer.dataset.results),
          null,
          2
        ),
      }),
      parent: document.body,
    });

    document
      .querySelector("#extraction-result-viewer")
      .append(extractionResultViewerEditor.dom);

  } else if(extractionResultViewer.dataset.format == 'XML') {
    // TODO why doesnt the syntax highlight work?
    // const parser = new DOMParser();
    // const parsedXML = parser.parseFromString(extractionResultViewer.dataset.results, 'text/xml');
    // console.log(new XMLSerializer().serializeToString(parsedXML));
    
    let extractionResultViewerEditor = new EditorView({
      state: EditorState.create({
        extensions: [
          basicSetup,
          xml(),
          EditorState.readOnly.of(true)
        ],
        doc: xmlFormat(extractionResultViewer.dataset.results, { indentation: '  ', lineSeparator: '\n' })
      }),
      parent: document.body,
    });

    document
      .querySelector("#extraction-result-viewer")
      .append(extractionResultViewerEditor.dom);
  }
}

// Enrichment URL Editor
const enrichmentField = document.querySelector(
  "#js-enrichment-url"
);

function updateEnrichmentUrl(value) {
  enrichmentField.value = value;
}

if (enrichmentField) {
  let enrichmentFieldEditor = new EditorView({
    state: EditorState.create({
      extensions: [
        basicSetup, 
        StreamLanguage.define(ruby),
        EditorView.updateListener.of(function (e) {
          updateEnrichmentUrl(e.state.doc.toString());
        })
      ],
      doc: enrichmentField.value,
    }),
    parent: document.body,
  });

  document
    .querySelector("#js-enrichment-editor")
    .append(enrichmentFieldEditor.dom);
}

