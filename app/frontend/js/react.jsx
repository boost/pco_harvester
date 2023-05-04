// Use this file for importing React apps

import React from 'react';
import ReactDOM from 'react-dom/client';

import TransformationApp from '~/js/apps/TransformationApp';

const transformationAppHTMLElement = document.querySelector("#js-transformation-app")

const root = ReactDOM.createRoot(transformationAppHTMLElement);
const props = JSON.parse(transformationAppHTMLElement.dataset.props);

root.render(
  <React.StrictMode>
    <TransformationApp {...props} />
  </React.StrictMode>
);

