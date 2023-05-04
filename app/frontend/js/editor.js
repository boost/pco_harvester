import {EditorState} from "@codemirror/state"
import {EditorView, basicSetup} from "codemirror"
import {json} from "@codemirror/lang-json"

// Job Extraction Result Viewer

const extraction_result_viewer = document.querySelector("#extraction-result-viewer");

if (extraction_result_viewer) {
    let extraction_result_viewer_editor = new EditorView({
    state: EditorState.create({
      extensions: [basicSetup, json(), EditorState.readOnly.of(true)],
      doc: JSON.stringify(JSON.parse(extraction_result_viewer.dataset.results), null, 2),
    }),
    parent: document.body,
  });

  document.querySelector('#extraction-result-viewer').append(extraction_result_viewer_editor.dom)
}


// Transformation Raw Data Record Viewer

const raw_data_record_viewer = document.querySelector("#raw-data-record-viewer");

if(raw_data_record_viewer) {
    let raw_data_record_viewer_editor = new EditorView({
    state: EditorState.create({
      extensions: [basicSetup, json(), EditorState.readOnly.of(true)],
      doc: JSON.stringify(JSON.parse(raw_data_record_viewer.dataset.record), null, 2),
    }),
    parent: document.body,
  });

  document.querySelector('#raw-data-record-viewer').append(raw_data_record_viewer_editor.dom)
}

// Transformation Preview Record Viewer

const transformation_record_viewer = document.querySelector("#transformation-record-viewer");

if(transformation_record_viewer) {
  let transformation_record_viewer_editor = new EditorView({
    state: EditorState.create({
      extensions: [basicSetup, json(), EditorState.readOnly.of(true)],
      doc: JSON.stringify(JSON.parse(transformation_record_viewer.dataset.record), null, 2),
    }),
    parent: document.body,
  });

  document.querySelector('#transformation-record-viewer').append(transformation_record_viewer_editor.dom)
}

