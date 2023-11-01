import { Modal } from "bootstrap";
import { each } from "lodash";

const modalIds = [
  "create-modal",
  "update-extraction-definition-modal",
  "add-harvest",
];

each(modalIds, (id) => {
  if (document.getElementById(id)) {
    initializeModalErrorDisplay(id);
  }
});

function initializeModalErrorDisplay(id) {
  const alert = document.getElementsByClassName("is-invalid");

  if (alert[0]) {
    new Modal(document.getElementById(id)).show();
  }
}
