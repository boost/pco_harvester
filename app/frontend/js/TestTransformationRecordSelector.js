import { bindTestForm } from './utils/test-form';
import editor from './editor';
import xmlFormat from 'xml-formatter';

bindTestForm('test', 'js-test-transformation-record-selector-button', 'js-transformation-definition-form', (response, _alertClass) => { let results = response.data.result;

  if(response.data.format == 'JSON') {
    results = JSON.stringify(response.data.result, null, 2)
  } else if(response.data.format == 'XML') {
    results = xmlFormat(response.data.result, { indentation: '  ', lineSeparator: '\n' });
  }
  
  editor('#js-record-selector-result', response.data.format, true, results)
});
