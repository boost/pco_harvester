import { EditorState } from "@codemirror/state";
import { EditorView, basicSetup } from "codemirror";
import { json } from "@codemirror/lang-json";
import xmlFormat from 'xml-formatter';

import { StreamLanguage } from "@codemirror/language";
import { ruby } from "@codemirror/legacy-modes/mode/ruby";
import { xml } from "@codemirror/legacy-modes/mode/xml";

export function editorExtensions(format, readOnly) {
  if(format == 'JSON') {
    return [ basicSetup, json(), EditorState.readOnly.of(readOnly) ];
  } else if(format == 'XML') {
    return [ basicSetup, StreamLanguage.define(xml), EditorState.readOnly.of(readOnly) ]
  } else if(format == 'Enrichment') {
    return [ basicSetup, StreamLanguage.define(ruby), EditorView.updateListener.of(function (e) { updateEnrichmentUrl(e.state.doc.toString()) }) ]
  }
}

export default function editor(editorID, format, readOnly, results) {
  const editorHTMLElement = document.querySelector(editorID);
  let editor = new EditorView({
    state: EditorState.create({
      extensions: editorExtensions(format, readOnly),
      doc: results
    }),
    parent: document.body,
  });

  document.querySelector(editorID).innerHTML = "";
  document
    .querySelector(editorID)
    .append(editor.dom);
}

// Job Extraction Result Viewer

const extractionResultViewer = document.querySelector(
  "#extraction-result-viewer"
);

if (extractionResultViewer) {
  const format = extractionResultViewer.dataset.format;
  let results = extractionResultViewer.dataset.results;
  
  if(format == 'JSON') {
    results = JSON.stringify(JSON.parse(results), null, 2 )
  } else if(format == 'XML') {
    results = xmlFormat(results, { indentation: '  ', lineSeparator: '\n' })
  }

  editor('#extraction-result-viewer', format, true, results);
}

// Enrichment URL Editor
const enrichmentField = document.querySelector(
  "#js-enrichment-url"
);


if (enrichmentField) {
  function updateEnrichmentUrl(value) {
    enrichmentField.value = value;
  }

  editor('#js-enrichment-editor', 'Enrichment', true, enrichmentField.value)
}

