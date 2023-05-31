import { bindTestForm } from './utils/test-form';

bindTestForm('test', 'js-test-destination', (response, alertClass) => {
  function alertMessage(statusCode) {
    if (statusCode >= 200 && statusCode < 300) {
      return "Successfully connected to destination.";
    } else {
      return "Invalid destination details. Please confirm that your API key has harvester privileges.";
    }
  }
  
  document.getElementById(
      "test-result"
    ).innerHTML = `<div class="${alertClass(
      response.data.status
    )}" role="alert">

  ${alertMessage(response.data.status)}
  </div>`;
}, () => {
  document.getElementById(
    "test-result"
  ).innerHTML = `<div class="alert alert-danger my-2" role="alert">
    Invalid destination details. Please confirm that your URL is valid.
  </div>`;
});
