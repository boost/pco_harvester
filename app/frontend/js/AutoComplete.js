import autoComplete from "@tarekraafat/autocomplete.js";
import { request } from "/js/utils/request";
import { each } from 'lodash';

const autoCompleteForms = document.querySelectorAll('.js-auto-complete');

each(autoCompleteForms, (form) => {
  const src = form.dataset.src;
  const placeholder = form.dataset.placeholder;
  const key = form.dataset.key;
  const selector = `#${form.id}`;
  
  const config = {
      selector: selector,
      placeHolder: placeholder,
      data: {
        src: JSON.parse(src),
        keys: [key]
      },
      resultItem: {
        highlight: true,
      },
      submit: true
  }

  new autoComplete(config);
  
  const pipelineID = document.querySelector('#js-pipeline-id').value;
  const harvestDefinitionID = document.querySelector('#js-harvest-definition-id').value;
  

  form.addEventListener('selection', (event) => {
    request
      .patch(`/pipelines/${pipelineID}/harvest_definitions/${harvestDefinitionID}`, {
        extraction_definition_id: event.detail.selection.value.id
      })
      .then(function (response) {
        location.reload();
      });
  });
});

