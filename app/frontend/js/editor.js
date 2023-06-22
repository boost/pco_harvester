import { EditorState } from "@codemirror/state";
import { EditorView, basicSetup } from "codemirror";
import { json } from "@codemirror/lang-json";
import xmlFormat from 'xml-formatter';

import { StreamLanguage } from "@codemirror/language";
import { ruby } from "@codemirror/legacy-modes/mode/ruby";
import { xml } from "@codemirror/legacy-modes/mode/xml";

// Job Extraction Result Viewer

const extractionResultViewer = document.querySelector(
  "#extraction-result-viewer"
);

function extractionResultViewerExtensions(format) {
  if(format == 'JSON') {
    return [ basicSetup, json(), EditorState.readOnly.of(true) ];
  } else if(format == 'XML') {
    return [ basicSetup, StreamLanguage.define(xml), EditorState.readOnly.of(true) ]
  }
}

function extractionResultViewerDocument(format, results) {
  if(format == 'JSON') {
    return JSON.stringify(JSON.parse(results), null, 2 )
  } else if(format == 'XML') {
    return xmlFormat(results, { indentation: '  ', lineSeparator: '\n' })
  }
}


if (extractionResultViewer) {
  const format = extractionResultViewer.dataset.format;
  const results = extractionResultViewer.dataset.results;
  
  let extractionResultViewerEditor = new EditorView({
    state: EditorState.create({
      extensions: extractionResultViewerExtensions(format),
      doc: extractionResultViewerDocument(format, results)
    }),
    parent: document.body,
  });

  document
    .querySelector("#extraction-result-viewer")
    .append(extractionResultViewerEditor.dom);
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

