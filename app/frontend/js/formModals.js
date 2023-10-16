// Open the create Modal on error so the user can see the validation issues
// and correct them without having to open the modal again.

import { Modal } from "bootstrap";
import editor from "./editor";
import xmlFormat from "xml-formatter";

const createModal = document.getElementById("create-modal");

if (createModal) {
  const alert = document.getElementsByClassName("is-invalid");

  if (alert[0]) {
    new Modal(document.getElementById("create-modal")).show();
  }
}

const addHarvestModal = document.getElementById("add-harvest");

if (addHarvestModal) {
  const addHarvestAlert = addHarvestModal.getElementsByClassName("is-invalid");

  if (addHarvestAlert[0]) {
    new Modal(document.getElementById("add-harvest")).show();
  }
}

const updateTransformationModal = document.getElementById('update-transformation-definition-modal');

if(updateTransformationModal) {
  const recordSelector = document.getElementById('transformation_definition_record_selector');
  const transformationDefinitionUpdateButton = document.getElementById('js-transformation-definition-update-button');
  const transformationDefinitionPreviewData = document.getElementById('js-transformation-definition-preview-data');

  let result = transformationDefinitionPreviewData.dataset.result;
  let format = transformationDefinitionPreviewData.dataset.format;
  let completed = transformationDefinitionPreviewData.dataset.completed;

  if (format == "JSON") {
    result = JSON.stringify(JSON.parse(result), null, 2);
  } else if (format == "XML") {
    result = xmlFormat(result, {
      indentation: "  ",
      lineSeparator: "\n",
    });
  }

  editor("#js-record-selector-result", format, true, result);

  if(recordSelector.value == '' && completed == 'true') {
    new Modal(document.getElementById("update-transformation-definition-modal")).show();
    transformationDefinitionUpdateButton.disabled = true;
  }

  recordSelector.addEventListener('input', (event) => {
    if(event.target.value == '') {
      transformationDefinitionUpdateButton.disabled = true;
    } else {
      transformationDefinitionUpdateButton.disabled = false;
    }
  })
}
