
import { request } from "./utils/request";

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

    function alertMessage(statusCode) {
      if (statusCode >= 200 && statusCode < 300) {
        return "Successfully connected to destination.";
      } else {
        return "Invalid destination details. Please confirm that your API key has harvester privileges.";
      }
    }

    function somethingWentWrong() {
      document.getElementById(
        "test-result"
      ).innerHTML = `<div class="alert alert-danger my-2" role="alert">
        Invalid destination details. Please confirm that your URL is valid.
      </div>`;
    }

    function sendData(form) {
      // Bind the FormData object and the form element
      const FD = new FormData(form);
      FD.set("_method", "post");
      const path = `${form.action.replace(/\/\d+$/, "")}/test`;
      // Fetches the response
      request
        .post(path, FD)
        .then(function (response) {
          document.getElementById(
            "test-result"
          ).innerHTML = `<div class="${alertClass(
            response.data.status
          )}" role="alert">
        ${alertMessage(response.data.status)}
        </div>`;
        })
        .catch(function (error) {
          somethingWentWrong();
        });
    }

    const button = this.getElementById("js-test-destination");

    if (button) {
      const form = button.closest("form");
      button.addEventListener("click", (event) => {
        sendData(form);
      });
    }
  },
  false
);
