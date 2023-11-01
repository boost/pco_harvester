import { Modal } from "bootstrap";
import { each } from "lodash";

const updateExtractionDefinitionModal = document.getElementById(
  "update-extraction-definition-modal"
);

if (updateExtractionDefinitionModal) {
  const updateExtractionDefinitionAlert =
    updateExtractionDefinitionModal.getElementsByClassName("is-invalid");

  if (updateExtractionDefinitionAlert[0]) {
    new Modal(
      document.getElementById("update-extraction-definition-modal")
    ).show();
  }

  const extractionDefinitionFormat = document.getElementById(
    "js-extraction-definition-format"
  );
  const splitDropdown = document.getElementById(
    "js-extraction-definition-split-dropdown"
  );

  if (splitDropdown != null) {
    toggleSplitElements(extractionDefinitionFormat.value);

    extractionDefinitionFormat.addEventListener("change", (event) => {
      toggleSplitElements(event.target.value);
    });

    splitDropdown.addEventListener("change", () => {
      toggleSplitElements(extractionDefinitionFormat.value);
    });

    function toggleSplitElements(format) {
      const elements = document.getElementsByClassName("js-split");
      const splitDropdownContainers = document.getElementsByClassName(
        "js-extraction-definition-split-dropdown-container"
      );
      const splitSelectorContainers = document.getElementsByClassName(
        "js-extraction-definition-split-selector-container"
      );
      const splitSelector = document.getElementById(
        "js-extraction-definition-split-selector"
      );

      if (format == "XML") {
        each(splitDropdownContainers, (container) => {
          container.classList.remove("d-none");
        });

        if (splitDropdown.value == "true") {
          each(splitSelectorContainers, (container) => {
            container.classList.remove("d-none");
          });
        } else {
          each(splitSelectorContainers, (container) => {
            container.classList.add("d-none");
            splitSelector.value = "";
          });
        }
      } else {
        each(elements, (element) => {
          element.classList.add("d-none");
        });

        splitDropdown.value = "false";
        splitSelector.value = "";
      }
    }
  }
}
