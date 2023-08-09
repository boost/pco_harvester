import { request } from "./request";

export function bindTestForm(
  testRoute,
  buttonId,
  formId,
  successCallback,
  failureCallback
) {
  document.addEventListener(
    "DOMContentLoaded",
    function () {
      function alertClass(statusCode) {
        if (statusCode >= 200 && statusCode < 300) {
          return "my-2 alert alert-success";
        } else {
          return "my-2 alert alert-danger";
        }
      }

      function sendData(form) {
        // Bind the FormData object and the form element
        const FD = new FormData(form);
        FD.set("_method", "post");
        const path = `${form.action.replace(/\/\d+$/, "")}/${testRoute}`;
        // Fetches the response
        request
          .post(path, FD)
          .then(function (response) {
            successCallback(response, alertClass);
          })
          .catch(function (error) {
            failureCallback(error);
          });
      }

      const button = this.getElementById(buttonId);

      if (button) {
        const form = this.getElementById(formId);
        button.addEventListener("click", (event) => {
          sendData(form);
        });
      }
    },
    false
  );
}
