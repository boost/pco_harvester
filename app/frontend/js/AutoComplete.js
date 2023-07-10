import autoComplete from "@tarekraafat/autocomplete.js";
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

  form.addEventListener('selection', (event) => {
    console.log(event.detail.selection.value.id);
  });
});

