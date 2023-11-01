import { Modal } from "bootstrap";

const addHarvestModal = document.getElementById("add-harvest");

if (addHarvestModal) {
  const addHarvestAlert = addHarvestModal.getElementsByClassName("is-invalid");

  if (addHarvestAlert[0]) {
    new Modal(document.getElementById("add-harvest")).show();
  }
}
