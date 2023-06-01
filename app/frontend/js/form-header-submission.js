const contentSourceFormSubmit = document.getElementById('js-content-source-form-submit');

if(contentSourceFormSubmit) {
  contentSourceFormSubmit.addEventListener("click", (event) => {
    document.getElementById('js-content-source-form').submit();
  });
}

const extractionFormSubmit = document.getElementById('js-extraction-definition-form-submit');

if(extractionFormSubmit) {
  extractionFormSubmit.addEventListener("click", (event) => {
    document.getElementById('js-extraction-definition-form').submit();
  });
}

const transformationFormSubmit = document.getElementById('js-transformation-definition-form-submit');

if(transformationFormSubmit) {
  transformationFormSubmit.addEventListener("click", (event) => {
    document.getElementById('js-transformation-definition-form').submit();
  });
}

const harvestFormSubmit = document.getElementById('js-harvest-definition-form-submit');

if(harvestFormSubmit) {
  harvestFormSubmit.addEventListener("click", (event) => {
    document.getElementById('js-harvest-definition-form').submit();
  });
}

const destinationFormSubmit = document.getElementById('js-destination-form-submit');

if(destinationFormSubmit) {
  destinationFormSubmit.addEventListener("click", (event) => {
    document.getElementById('js-destination-form').submit();
  });
}
