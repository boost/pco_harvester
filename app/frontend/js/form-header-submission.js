// The button to submit the form is in the header of the page.
// If you want to follow this pattern, add an ID to your form and add a data-form attribute
// to your button which has the value of the ID of the form that you want to submit.

import { each } from "lodash";

const formSubmissionButtons = document.querySelectorAll("[data-form]");

each(formSubmissionButtons, (button) => {
  button.addEventListener("click", (event) => {
    document.getElementById(button.dataset.form).submit();
  });
});
