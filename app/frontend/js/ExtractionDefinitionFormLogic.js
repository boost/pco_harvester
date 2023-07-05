import { each } from 'lodash';

const extractionDefinitionPaginationTypeSelect = document.getElementById('js-extraction-definition-pagination-type');

if(extractionDefinitionPaginationTypeSelect) {
  const pageElements = document.getElementsByClassName('js-extraction-definition-page-form');
  const tokenisedElements = document.getElementsByClassName('js-extraction-definition-tokenised-form');

  extractionDefinitionPaginationLogic(extractionDefinitionPaginationTypeSelect.value);

  extractionDefinitionPaginationTypeSelect.addEventListener('change', (event) => {
    extractionDefinitionPaginationLogic(event.target.value);
  });

  function extractionDefinitionPaginationLogic(type) {
    if(type == 'page') {
      hideElements(tokenisedElements);
      showElements(pageElements);
    } else if(type == 'tokenised') {
      hideElements(pageElements);
      showElements(tokenisedElements);
    }
  }

  function showElements(elements) {
    each(elements, (element) => {
      element.style.display = 'block';
    });
  }

  function hideElements(elements) {
    each(elements, (element) => {
      element.style.display = 'none';
    });
  }
}



