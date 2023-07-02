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

  const extractionDefinitionAddHeader = document.getElementById('js-extraction-definition-add-header');

  if(extractionDefinitionAddHeader) {
    extractionDefinitionAddHeader.addEventListener('click', (event) => {

      const formElements = document.querySelector('#js-extraction-definition-headers').getElementsByClassName('form-control');
      const lastElement = formElements[formElements.length - 1];
      let newId;

      if(lastElement != undefined) {
        const lastId = lastElement.id.match(/.+(?<id>\d)/).groups.id;
        newId = parseInt(lastId) + 1;
      } else {
        newId = 0;
      }

      const headerForm = `
        <div class='row gy-3 mb-5 align-items-center'>
          <div class='col-4'>
            <label class='form-label' for='extraction_definition_headers_attributes_${newId}_name'>
              Header Name
            </label>                
          </div>
          
          <div class='col-8'>
            <input class='form-control' type='text' name='extraction_definition[headers_attributes][${newId}][name]'' id='extraction_definition_headers_attributes_${newId}_name'>
          </div>
          
          <div class='col-4'>
            <label class='form-label' for='extraction_definition_headers_attributes_${newId}_value'>
              Header Value
            </label>                
          </div>
        
          <div class='col-8'>
            <input class='form-control' type='text' name='extraction_definition[headers_attributes][${newId}][value]'' id='extraction_definition_headers_attributes_${newId}_value'>
          </div>
        </div>
      `;

      document.getElementById('js-extraction-definition-headers')
        .insertAdjacentHTML('beforeend', headerForm);

    });
  }
}



