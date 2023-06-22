import { bindTestForm } from './utils/test-form';
import { EditorState } from "@codemirror/state";
import { EditorView, basicSetup } from "codemirror";
import { json } from "@codemirror/lang-json";
import xmlFormat from 'xml-formatter';

import { StreamLanguage } from "@codemirror/language";
import { ruby } from "@codemirror/legacy-modes/mode/ruby";
import { xml } from "@codemirror/legacy-modes/mode/xml";

bindTestForm('test', 'js-test-transformation-record-selector-button', 'js-transformation-definition-form', (response, _alertClass) => {
    let transformationRecordSelectorResultExtensions = (format) => {
      if(format == 'JSON') {
        return [basicSetup, json(), EditorState.readOnly.of(true)]
      } else if(format == 'XML') {
        return [ basicSetup, StreamLanguage.define(xml), EditorState.readOnly.of(true) ]
      }
    }

    let transformationRecordSelectorResultDocument = (format, result) => {
      if(format == 'JSON') {
        return JSON.stringify(response.data, null, 2);
      } else if(format == 'XML') {
        return xmlFormat(result, { indentation: '  ', lineSeparator: '\n' });
      }
    } 
  
    let editor = new EditorView({
      state: EditorState.create({
        extensions: transformationRecordSelectorResultExtensions(response.data.format),
        doc: transformationRecordSelectorResultDocument(response.data.format, response.data.result)
      }),
      parent: document.body,
    });

    document.querySelector("#js-record-selector-result").innerHTML = "";
    document
      .querySelector("#js-record-selector-result")
      .append(editor.dom);
});
