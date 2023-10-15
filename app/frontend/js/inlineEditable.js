import { each } from "lodash";

const inlineEditableControls = document.getElementsByClassName(
  "js-inline-editable-control"
);

each(inlineEditableControls, (control) => {
  control.addEventListener("click", (event) => {
    const id = event.target.dataset.id;

    console.log(id);

    const content = document.getElementById(`${id}-content`);
    const form = document.getElementById(`${id}-form`);

    content.classList.toggle("d-none");
    form.classList.toggle("d-none");
  });
});
