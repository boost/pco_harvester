import { bindTestForm } from './utils/test-form';

bindTestForm('test', 'js-test-extraction-button', 'js-extraction-definition-form', (response, alertClass) => {
   document.getElementById(
      "test-result"
    ).innerHTML = `<div class="${alertClass(
      response.data.status
    )}" role="alert">
    <a href="${response.data.url}" target="_blank">${
      response.data.url
    }</a>
  </div>`;
}, () => {
  document.getElementById(
    "test-result"
  ).innerHTML = `<div class="alert alert-danger my-2" role="alert">
    Something went wrong. Please confirm your Extraction details are correct.
  </div>`;
});

