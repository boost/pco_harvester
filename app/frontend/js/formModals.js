// Open the create Modal on error so the user can see the validation issues
// and correct them without having to open the modal again.

import { Modal } from "bootstrap";
import editor from "./editor";
import xmlFormat from "xml-formatter";
import { Tooltip } from "bootstrap";
import { each } from "lodash";
import { bindTestForm } from "./utils/test-form";

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

const transformationDefinitionSettingsForms = document.getElementsByClassName(
  "js-transformation-definition-form"
);

if (transformationDefinitionSettingsForms) {
  each(transformationDefinitionSettingsForms, (form) => {
    const id = form.dataset.id;

    const recordSelector = document.getElementById(
      `js-transformation-definition-record-selector-${id}`
    );

    const transformationDefinitionUpdateButton = document.getElementById(
      `js-transformation-definition-submit-button-${id}`
    );

    const tooltip = Tooltip.getInstance(
      `#js-transformation-definition-submit-button-tooltip-${id}`
    );

    const transformationDefinitionPreviewData = document.getElementById(
      `js-transformation-definition-preview-data-${id}`
    );

    if (transformationDefinitionPreviewData) {
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

      editor(`#js-record-selector-result-${id}`, format, true, result);
      tooltip.disable();

      if (recordSelector.value == "") {
        transformationDefinitionUpdateButton.disabled = true;
        tooltip.enable();
      }

      if (recordSelector.value == "" && completed == "true") {
        new Modal(
          document.getElementById("update-transformation-definition-modal")
        ).show();
      }

      recordSelector.addEventListener("input", (event) => {
        if (event.target.value == "") {
          transformationDefinitionUpdateButton.disabled = true;
          tooltip.enable();
        } else {
          transformationDefinitionUpdateButton.disabled = false;
          tooltip.disable();
        }
      });

      bindTestForm(
        "test",
        `js-test-transformation-record-selector-button-${id}`,
        `js-transformation-definition-form-${id}`,
        (response, _alertClass) => {
          let results = response.data.result;

          if (response.data.format == "JSON") {
            results = JSON.stringify(response.data.result, null, 2);
          } else if (response.data.format == "XML") {
            results = xmlFormat(response.data.result, {
              indentation: "  ",
              lineSeparator: "\n",
            });
          }

          editor(
            `#js-record-selector-result-${id}`,
            response.data.format,
            true,
            results
          );
        }
      );
    }
  });
}
